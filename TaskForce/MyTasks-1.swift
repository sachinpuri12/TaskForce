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

class MyNewTasks: UITableViewController {
    

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
    
    var taskKeys = [String]()
    
    
    override func viewDidLoad() {
        //setUserKeyIfNil()
        db = FIRDatabase.database().reference()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor(colorLiteralRed: 0.18, green: 0.24, blue: 0.28, alpha: 1)
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(colorLiteralRed: 0.75, green: 0.75, blue: 0.75, alpha: 1)
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
        self.loadTables()
        self.taskTable.reloadData()
    }
    func loadTables(){
        
        self.clearRunArrays()
        self.clearRequestArrays()
       
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

                if acceptor == self.username{
                    self.runTitleArray.append(title)
                    self.runNameArray.append(poster)
                    self.runMoneyArray.append(price)
                    self.runLocArray.append(place)
                    self.runTaskArray.append(task)
                    self.runTaskStatusArray.append(taskStatus)
                    self.runTaskKeys.append(item)
                }

                if poster == self.username {
                    self.requestTitleArray.append(title)
                    self.requestNameArray.append(poster)
                    self.requestMoneyArray.append(price)
                    self.requestLocArray.append(place)
                    self.requestTaskArray.append(task)
                    self.requestTaskStatusArray.append(taskStatus)
                    self.requestTaskKeys.append(item)
                }
                self.taskTable.reloadData()
            })
            print("*****************")
        }

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
        taskTable.separatorStyle = .none
        loadTables()
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
            myCell.setInfo(money: runMoneyArray[indexPath.row], name: runNameArray[indexPath.row], task: runTaskArray[indexPath.row], loc: runLocArray[indexPath.row])
            myCell.selectedTaskStatus = runTaskStatusArray[indexPath.row]
            myCell.selectedTaskKey = runTaskKeys[indexPath.row]
            break
        case 1:
            myCell.setInfo(money: requestMoneyArray[indexPath.row], name: requestNameArray[indexPath.row], task: requestTaskArray[indexPath.row], loc: requestLocArray[indexPath.row])
            myCell.selectedTaskStatus = requestTaskStatusArray[indexPath.row]
            myCell.selectedTaskKey = requestTaskKeys[indexPath.row]
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
        selectedTask = taskKeys[indexPath.section]
    }
}
