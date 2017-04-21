//
//  Profile.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class MyTasks: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var db: FIRDatabaseReference!
    // pickerview outlets/arrays
    @IBOutlet weak var runText: UITextField!
    @IBOutlet weak var runPicker: UIPickerView!
    @IBOutlet weak var requestText: UITextField!
    @IBOutlet weak var requestPicker: UIPickerView!
    var runSort = ["All","Accepted", "Completed"]
    var requestSort = ["All", "Requested", "Accepted", "Completed"]
    var selectedPickerTag = Int()
    var selectedTaskStatus = String()
    var selectedTaskKey = String()
    
    
    
    // tableview outlets/variables
    @IBOutlet weak var runTable: UITableView!
    @IBOutlet weak var requestTable: UITableView!
    
    var username = String()
    
    var runNameArray = [String]()
    var runTitleArray = [String]()
    var runTaskArray = [String]()
    var runLocArray = [String]()
    var runMoneyArray = [Int]()
    var runTaskStatusArray = [String]()
    var runTaskKeys = [String]()
    
    var requestNameArray = [String]()
    var requestTitleArray = [String]()
    var requestTaskArray = [String]()
    var requestLocArray = [String]()
    var requestMoneyArray = [Int]()
    var requestTaskStatusArray = [String]()
    var requestTaskKeys = [String]()
    
    var setDelegateCount = Int()
    
    var taskKeys = [String]()
    
   // populating pickerviews
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows: Int = runSort.count
        if pickerView == requestPicker {
            countRows = self.requestSort.count
        }
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == runPicker {
            let titleRow = runSort[row]
            return titleRow
        }
        else if pickerView == requestPicker{
            let titleRow = requestSort[row]
            return titleRow
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == runPicker {
            self.runText.text = self.runSort[row]
            self.pullData(status: runText.text!, pickerTag: 1)
//            self.runPicker.isHidden = true
            self.runText.endEditing(true)
        }
            
        else {
            self.requestText.text = self.requestSort[row]
            self.pullData(status: requestText.text!, pickerTag: 2)
//            self.requestPicker.isHidden = true
            self.requestText.endEditing(true)
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.runText){
            self.runPicker.isHidden = false
        }
        else if (textField == self.requestText){
            self.requestPicker.isHidden = false
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.runText){
            self.runPicker.isHidden = false
            
        }
        else if (textField == self.requestText){
            self.requestPicker.isHidden = false
            
        }
        return false
    }

    
    // table populating
    
    override func viewDidLoad() {
        
        db = FIRDatabase.database().reference()
        super.viewDidLoad()
        getUsername()
        clearRunArrays()
        clearRequestArrays()
        self.runPicker.delegate = self
        self.runPicker.dataSource = self
        self.runPicker.reloadAllComponents()
        self.runText.inputView = runPicker
        self.runText.text = "All"
        self.requestPicker.delegate = self
        self.requestPicker.dataSource = self
        self.requestPicker.reloadAllComponents()
        self.requestText.inputView = requestPicker
        self.requestText.text = "All"
        self.pullData(status: self.runText.text!, pickerTag: 1)
        self.pullData(status: self.requestText.text!, pickerTag: 2)
        
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor(colorLiteralRed: 0.18, green: 0.24, blue: 0.28, alpha: 1)
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(colorLiteralRed: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    func setTableDelegateDataSource(){
        
        self.runTable.delegate = self
        self.runTable.dataSource = self
        self.runTable.tag = 1
        self.requestTable.delegate = self
        self.requestTable.dataSource = self
        self.requestTable.tag = 2
        self.setDelegateCount = self.setDelegateCount + 1
       

    }
    
    func clearRunArrays(){
        self.runNameArray.removeAll()
        self.runTitleArray.removeAll()
        self.runTaskArray.removeAll()
        self.runLocArray.removeAll()
        self.runMoneyArray.removeAll()
        self.runTaskStatusArray.removeAll()
        self.runTaskKeys.removeAll()
        
    }
    
    func clearRequestArrays(){
        self.requestNameArray.removeAll()
        self.requestTitleArray.removeAll()
        self.requestTaskArray.removeAll()
        self.requestLocArray.removeAll()
        self.requestMoneyArray.removeAll()
        self.requestTaskStatusArray.removeAll()
        self.requestTaskKeys.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getUsername(){
        // get username
        let id = UserDefaults.standard.object(forKey: "user_id_taskforce") as! String
    
        let userRef = db.child("users")
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children{
                let userID = (child as AnyObject).key!
                if (id == userID) {
                    self.db.child("users/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        self.username = value?["username"] as? String ?? ""
                    })
                }
            }
            
        })
    }
    
    
    func pullData(status: String, pickerTag: Int){
        //get all task keys
        let taskRef = db.child("tasks")
        taskRef.observeSingleEvent(of: .value, with: { snapshot in
            self.taskKeys.removeAll()
            for child in snapshot.children{
                let taskID = (child as AnyObject).key!
                self.taskKeys.append(taskID)
            }
            print(self.taskKeys)
        })
        if pickerTag == 1{
            self.clearRunArrays()
        }
        else{
            self.clearRequestArrays()
        }
            for item in self.taskKeys{
                self.db.child("tasks/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let poster = value?["name"] as? String ?? ""
                    let acceptor = value?["acceptor"] as? String ?? ""
                    let title = value?["title"] as? String ?? ""
                    let task = value?["description"] as? String ?? ""
                    let place = value?["location"] as? String ?? ""
                    let price = value?["tip"] as? Int ?? 0
                    let taskStatus = value?["status"] as? String ?? ""
                    print("Poster is \(poster)")
                    print("Username is \(self.username)")
                    
                
                    // runPicker
                    
                    if pickerTag == 1{
                        
                        print("PICKERTAG: 1 run picker")
                        print("acceptor is \(acceptor)")
                        if acceptor == self.username{
                            if status == "All"{
                                print("STATUS: All")
                                self.runTitleArray.append(title)
                                self.runNameArray.append(poster)
                                self.runMoneyArray.append(price)
                                self.runLocArray.append(place)
                                self.runTaskArray.append(task)
                                self.runTaskStatusArray.append(taskStatus)
                                self.runTaskKeys.append(item)

                            }
                            else if status == "Accepted"{
                                print("STATUS: Accepted")
                                if taskStatus == "accepted"{
                                    self.runTitleArray.append(title)
                                    self.runNameArray.append(poster)
                                    self.runMoneyArray.append(price)
                                    self.runLocArray.append(place)
                                    self.runTaskArray.append(task)
                                    self.runTaskStatusArray.append(taskStatus)
                                    self.runTaskKeys.append(item)

                                }
                            }
                            else if status == "Completed"{
                                print("STATUS: Completed")
                                if taskStatus == "completed"{
                                    self.runTitleArray.append(title)
                                    self.runNameArray.append(poster)
                                    self.runMoneyArray.append(price)
                                    self.runLocArray.append(place)
                                    self.runTaskArray.append(task)
                                    self.runTaskStatusArray.append(taskStatus)
                                    self.runTaskKeys.append(item)
 
                                }
                            }
                            print(self.runTitleArray)
                        }
                    }
                        
                    // request picker
                        
                    else if pickerTag == 2{
                        
                         print("PICKERTAG: 2 request picker")
                        if poster == self.username {
                            // requester if statements
                            if status == "All"{
                                print("STATUS: All")
                                self.requestTitleArray.append(title)
                                self.requestNameArray.append(poster)
                                self.requestMoneyArray.append(price)
                                self.requestLocArray.append(place)
                                self.requestTaskArray.append(task)
                                self.requestTaskStatusArray.append(taskStatus)
                                self.requestTaskKeys.append(item)

                            }
                            else if status == "Requested"{
                                print("STATUS: Requested")
                                if taskStatus == "requested"{
                                    self.requestTitleArray.append(title)
                                    self.requestNameArray.append(poster)
                                    self.requestMoneyArray.append(price)
                                    self.requestLocArray.append(place)
                                    self.requestTaskArray.append(task)
                                    self.requestTaskStatusArray.append(taskStatus)
                                    self.requestTaskKeys.append(item)
 
                                }
                            }
                            else if status == "Accepted"{
                                print("STATUS: Accepted")
                                if taskStatus == "accepted"{
                                    self.requestTitleArray.append(title)
                                    self.requestNameArray.append(poster)
                                    self.requestMoneyArray.append(price)
                                    self.requestLocArray.append(place)
                                    self.requestTaskArray.append(task)
                                    self.requestTaskStatusArray.append(taskStatus)
                                    self.requestTaskKeys.append(item)

                                }
                                
                            }
                            else if status == "Completed"{
                                print("STATUS: Completed")
                                if taskStatus == "completed"{
                                    self.requestTitleArray.append(title)
                                    self.requestNameArray.append(poster)
                                    self.requestMoneyArray.append(price)
                                    self.requestLocArray.append(place)
                                    self.requestTaskArray.append(task)
                                    self.requestTaskStatusArray.append(taskStatus)
                                    self.requestTaskKeys.append(item)
  
                                }
                            }
                            print(self.requestTitleArray)
                            
                        }
                    }
                    self.setTableDelegateDataSource()
                    if pickerTag == 1{
                        self.runTable.reloadData()
                    }
                    else {
                        self.requestTable.reloadData()  
                    }
                })
                
                print("*****************")
            }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            return self.runTitleArray.count
        }
        else{
            return self.requestTitleArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        setTableDelegateDataSource()
        if tableView.tag == 1{
            let myCell = self.runTable.dequeueReusableCell(withIdentifier: "runCell", for: indexPath) as! TaskFeedCell
            print("PRICE:")
            print(self.runMoneyArray[indexPath.row])
            print("POSTER:")
            print(self.runNameArray[indexPath.row])
            print("LOCATION:")
            print(self.runLocArray[indexPath.row])
            print("DESCRIPTION:")
            print(self.runTaskArray[indexPath.row])
            
            myCell.setInfo(money: runMoneyArray[indexPath.row], name: runNameArray[indexPath.row], task: runTaskArray[indexPath.row], loc: runLocArray[indexPath.row])
            myCell.selectedTaskStatus = runTaskStatusArray[indexPath.row]
            myCell.selectedTaskKey = runTaskKeys[indexPath.row]
            return myCell
        }
        else{
            let myCell = self.requestTable.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! TaskFeedCell
            print("PRICE:")
            print(requestMoneyArray[indexPath.row])
            print("POSTER:")
            print(requestNameArray[indexPath.row])
            print("LOCATION:")
            print(requestLocArray[indexPath.row])
            print("DESCRIPTION:")
            print(requestTaskArray[indexPath.row])
            myCell.setInfo(money: requestMoneyArray[indexPath.row], name: requestNameArray[indexPath.row], task: requestTaskArray[indexPath.row], loc: requestLocArray[indexPath.row])
            myCell.selectedTaskStatus = requestTaskStatusArray[indexPath.row]
            myCell.selectedTaskKey = requestTaskKeys[indexPath.row]
            return myCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            selectedPickerTag = 1
            selectedTaskStatus = self.runTaskStatusArray[indexPath.row]
            selectedTaskKey = self.runTaskKeys[indexPath.row]
            print(selectedTaskStatus)
            if selectedTaskStatus == "completed"{
                self.performSegue(withIdentifier: "CompleteTaskInfo", sender: TaskFeedCell())
            }
            else if selectedTaskStatus == "accepted" {
                self.performSegue(withIdentifier: "MyTaskInfo", sender: TaskFeedCell())
            }
        }
        else{
            selectedPickerTag = 2
            selectedTaskStatus = self.requestTaskStatusArray[indexPath.row]
            selectedTaskKey = self.requestTaskKeys[indexPath.row]
            print(selectedTaskStatus)
            if selectedTaskStatus == "completed" {
                self.performSegue(withIdentifier: "CompleteTaskInfo", sender: TaskFeedCell())
            }
            else if selectedTaskStatus == "accepted" {
                self.performSegue(withIdentifier: "MyTaskInfo", sender: TaskFeedCell())
            }
            else if selectedTaskStatus == "requested" {
                self.performSegue(withIdentifier: "MyTaskInfo", sender: TaskFeedCell())
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CompleteTaskInfo" {
            let dest = segue.destination as! CompleteInfo
            dest.pickerTag = selectedPickerTag
            dest.taskStatus = selectedTaskStatus
            dest.taskKey = selectedTaskKey

        }
        else if segue.identifier == "MyTaskInfo"{
            let dest = segue.destination as! MyTaskInfo
            dest.pickerTag = selectedPickerTag
            dest.taskStatus = selectedTaskStatus
            dest.taskKey = selectedTaskKey

        }
    }
    
    

    
}

