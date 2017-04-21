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

var selectedTask: String = ""
var groupNames = [String]()
var userKeys = [String]()
class TaskFeed: UITableViewController {
    
    
    @IBOutlet var feedTable: UITableView!
    var db: FIRDatabaseReference!
    var idArray = [String]()
    var nameArray = [String]()
    var titleArray = [String]()
    var taskArray = [String]()
    var locArray = [String]()
    var moneyArray = [Int]()
    var taskStatusArray = [String]()
    var tasksArray = [String]()
    var taskKeys = [String]()
    
    
    
    override func viewDidLoad() {
        setUserKeyIfNil()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor(colorLiteralRed: 0.18, green: 0.24, blue: 0.28, alpha: 1)
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(colorLiteralRed: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        super.viewDidLoad()
        
        print("Global user is \(globalUser)")
        
    }

    
    func loadTables(){
        
        self.idArray.removeAll()
        self.nameArray.removeAll()
        self.titleArray.removeAll()
        self.taskArray.removeAll()
        self.locArray.removeAll()
        self.moneyArray.removeAll()
        self.tasksArray.removeAll()
        self.taskKeys.removeAll()
        self.feedTable.reloadData()
        
        db = FIRDatabase.database().reference()
        let ref = FIRDatabase.database().reference()
        let taskRef = ref.child("tasks")
        
        taskRef.observeSingleEvent(of: .value, with: { snapshot in
            
            
            for child in snapshot.children{
                let userID = (child as AnyObject).key!
                self.taskKeys.append(userID)
            }
            
            
            for item in self.taskKeys{
                ref.child("tasks/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    
                    
                    let value = snapshot.value as? NSDictionary
                    let group = value?["group"] as? String ?? ""
                    
                    if groupNames.contains(group){
                        if(value?["status"] as? String == "requested") {
                            let name = value?["name"] as? String ?? ""
                            let title = value?["title"] as? String ?? ""
                            let task = value?["description"] as? String ?? ""
                            let place = value?["location"] as? String ?? ""
                            let price = value?["tip"] as? Int ?? 0
                            let taskStatus = value?["status"] as? String ?? ""
                            self.idArray.append(snapshot.key)
                            self.titleArray.append(title)
                            self.nameArray.append(name)
                            self.moneyArray.append(price)
                            self.locArray.append(place)
                            self.taskArray.append(task)
                            self.taskStatusArray.append(taskStatus)
                        }
                    }
                    
                    // ...
                    self.feedTable.reloadData()
                })
                
            }
            
        })
    }
    
    func getGroups(userId: String){
        print(userId)
        let ref = FIRDatabase.database().reference()
        ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let groups = (value?["groups"] as? NSDictionary)
            if groups == nil{
                let alert = UIAlertController(title: "No Groups!", message: "Please add groups!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                groupNames = groups?.allValues as! [String]
            }
            
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "user_id_taskforce") as? String != nil{
            let id = UserDefaults.standard.object(forKey: "user_id_taskforce") as! String
            self.getGroups(userId: id)
        }
        feedTable.separatorStyle = .none
        loadTables()
    }
    
    
    //loading the table
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return nameArray.count
//    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return nameArray.count
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
        
        let myCell = self.feedTable.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskFeedCell
        myCell.setInfo(money: moneyArray[indexPath.section], name: nameArray[indexPath.section], task: taskArray[indexPath.section], loc: locArray[indexPath.section])
        myCell.selectedTaskStatus = taskStatusArray[indexPath.section]
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = taskKeys[indexPath.section]
    }
    
   
    
}

func setUserKeyIfNil(){
    
    if UserDefaults.standard.object(forKey: "user_id_taskforce") as? String == nil{
        userKeys.removeAll()
        let ref = FIRDatabase.database().reference()
        let usersRef = ref.child("users")
        usersRef.observeSingleEvent(of: .value, with: { snapshot in
            userKeys.removeAll()
            for child in snapshot.children{
                let userID = (child as AnyObject).key!
                userKeys.append(userID)
            }
            print(userKeys)
            for item in userKeys{
                ref.child("users/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let username = value?["username"] as? String ?? ""
                    print(username)
                    print(globalId)
                    if username == globalUser {
                        print(username)
                        print(item)
                        UserDefaults.standard.set(item, forKey: "user_id_taskforce")
                        print(UserDefaults.standard.object(forKey: "user_id_taskforce") as! String)
                    }
                })
            }
        })
    }
}
