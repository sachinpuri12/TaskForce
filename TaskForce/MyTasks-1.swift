//
//  TaskFeed.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var mySelectedTask = String()
class MyNewTasks: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    var acceptorBool = true
    
    @IBOutlet weak var filterText: UITextField!
    
    @IBOutlet var taskTable: UITableView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    var db: FIRDatabaseReference!
    
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
    
    var runSort = ["All","Accepted", "Completed"]
    var requestSort = ["All", "Requested", "Accepted", "Completed"]
    
    var taskKeys = [String]()
    var myPicker = UIPickerView()
    
    var segueShouldOccur = false
    
    override func viewDidLoad() {
        //setUserKeyIfNil()
        db = FIRDatabase.database().reference()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor(colorLiteralRed: 0.18, green: 0.24, blue: 0.28, alpha: 1)
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(colorLiteralRed: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        self.myPicker = UIPickerView()
        self.filterText.delegate = self
        self.filterText.inputView = self.myPicker
        self.myPicker.delegate = self
        self.myPicker.dataSource = self
        
       
        segueShouldOccur = false
        super.viewDidLoad()
        
        //print("Global user is \(globalUser)")
        
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
    
    @IBAction func switchTables(_ sender: Any) {
        self.filterText.text = "All"
        self.pullData(status: filterText.text!)
        // self.loadTables()
        self.taskTable.reloadData()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getUsername()
        self.pullData(status: filterText.text!)
        // self.loadTables()
        self.taskTable.reloadData()
        taskTable.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var returnValue = 0
        
        switch(segmentedController.selectedSegmentIndex)
        {
        case 0:
            returnValue = self.runTitleArray.count
            break
        case 1:
            returnValue = self.requestTitleArray.count
            break
        default:
            break
        }
        
        return returnValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellSpacingHeight: CGFloat = 2
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = self.taskTable.dequeueReusableCell(withIdentifier: "MyTaskCell", for: indexPath) as! TaskFeedCell
        
        switch(segmentedController.selectedSegmentIndex)
        {
            
        case 0:
            
            myCell.setInfo(money: runMoneyArray[indexPath.row], name: runNameArray[indexPath.row], task: runTitleArray[indexPath.row], loc: runLocArray[indexPath.row])
            myCell.selectedTaskStatus = runTaskStatusArray[indexPath.row]
            myCell.selectedTaskKey = runTaskKeys[indexPath.row]
            break
        case 1:
            
            myCell.setInfo(money: requestMoneyArray[indexPath.section], name: requestNameArray[indexPath.section], task: requestTitleArray[indexPath.section], loc: requestLocArray[indexPath.section])
            myCell.selectedTaskStatus = requestTaskStatusArray[indexPath.section]
            myCell.selectedTaskKey = requestTaskKeys[indexPath.section]
            
            break
        default:
            break
        }
        return myCell
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("got here")
        segueShouldOccur = true
        if segmentedController.selectedSegmentIndex == 0 {
            print("1")
            globalMyTaskKey = runTaskKeys[indexPath.section]
            globalPickerTag = 1
            
            if runTaskStatusArray[indexPath.section] == "completed" {
                self.performSegue(withIdentifier: "CompleteTaskInfo", sender: TaskFeedCell())
            }
            else if runTaskStatusArray[indexPath.section] == "accepted" {
                self.performSegue(withIdentifier: "MyTaskInfo", sender: TaskFeedCell())
            }
            else if runTaskStatusArray[indexPath.section] == "requested" {
                self.performSegue(withIdentifier: "MyTaskInfo", sender: TaskFeedCell())
            }
            
        }
        else {
            globalMyTaskKey = requestTaskKeys[indexPath.section]
            globalPickerTag = 2
            print("2")
            if requestTaskStatusArray[indexPath.section] == "completed" {
                self.performSegue(withIdentifier: "CompleteTaskInfo", sender: TaskFeedCell())
            }
            else if requestTaskStatusArray[indexPath.section] == "accepted" {
                self.performSegue(withIdentifier: "MyTaskInfo", sender: TaskFeedCell())
            }
            else if requestTaskStatusArray[indexPath.section] == "requested" {
                self.performSegue(withIdentifier: "MyTaskInfo", sender: TaskFeedCell())
            }
            
        }
   
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows: Int = runSort.count
        if segmentedController.selectedSegmentIndex == 1 {
            countRows = self.requestSort.count
        }
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if segmentedController.selectedSegmentIndex == 0 {
            let titleRow = runSort[row]
            return titleRow
        }
        else {
            let titleRow = requestSort[row]
            return titleRow
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if segmentedController.selectedSegmentIndex == 0 {
            self.filterText.text = self.runSort[row]

        }
        else {
            self.filterText.text = self.requestSort[row]

            
        }
        self.pullData(status: self.filterText.text!)
        self.myPicker.isHidden = true
        self.filterText.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.myPicker.isHidden = false
    }
    
    func pullData(status: String){
        //get all task keys
        let taskRef = db.child("tasks")
        taskRef.observeSingleEvent(of: .value, with: { snapshot in

            if let _ = snapshot.value as? NSNull {
                return
            } else {
                
                self.taskKeys.removeAll()
                for child in snapshot.children{
                    let taskID = (child as AnyObject).key!
                    self.taskKeys.append(taskID)
                }
                
                self.clearRunArrays()
                self.clearRequestArrays()
                self.taskTable.reloadData()
                for item in self.taskKeys{
                    self.db.child("tasks/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let _ = snapshot.value as? NSNull {
                            return
                        } else {
                            let value = snapshot.value as? NSDictionary
                            let poster = value?["name"] as? String ?? ""
                            let acceptor = value?["acceptor"] as? String ?? ""
                            let title = value?["title"] as? String ?? ""
                            let task = value?["description"] as? String ?? ""
                            let place = value?["location"] as? String ?? ""
                            let price = value?["tip"] as? Int ?? 0
                            let taskStatus = value?["status"] as? String ?? ""
 
                            if self.segmentedController.selectedSegmentIndex == 0{
                                if acceptor == self.username{
                                    if status == "All"{
                                        self.runTitleArray.append(title)
                                        self.runNameArray.append(poster)
                                        self.runMoneyArray.append(price)
                                        self.runLocArray.append(place)
                                        self.runTaskArray.append(task)
                                        self.runTaskStatusArray.append(taskStatus)
                                        self.runTaskKeys.append(item)
                                    
                                    }
                                    else if status == "Accepted"{
                                        //  print("STATUS: Accepted")
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
                                        // print("STATUS: Completed")
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
                                    // print(self.runTitleArray)
                                }
                            }
                            // request picker
                            
                            else if self.segmentedController.selectedSegmentIndex == 1{
                            
                                //  print("PICKERTAG: 2 request picker")
                                if poster == self.username {
                                // requester if statements
                                    if status == "All"{
                                    
                                        self.requestTitleArray.append(title)
                                        print(poster)
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
                                
                                
                                }
                            }
                            self.taskTable.reloadData()
                        }
                    })
                    
                }
                
            }
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyTaskInfo"{
            let dest = segue.destination as! MyTaskInfo
        }
        else if segue.identifier == "CompleteInfo"{
            let dest = segue.destination as! CompleteInfo
        }
    }
    
  ////  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
  /*      if identifier == "CompleteTaskInfo" {
            if !segueShouldOccur {
                return false
            }
        }
        else if identifier == "MyTaskInfo"{
            if !segueShouldOccur {
                return false
            }
        }
        return true
    */
    
  // }
    
}
