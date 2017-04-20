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
class TaskFeed: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTable: UITableView!
    var db: FIRDatabaseReference!
    var idArray = [String]()
    var nameArray = [String]()
    var titleArray = [String]()
    var taskArray = [String]()
    var locArray = [String]()
    var moneyArray = [Int]()
    var tasksArray = [String]()
    var taskKeys = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.delegate = self
        feedTable.dataSource = self
        
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
                            self.idArray.append(snapshot.key)
                            self.titleArray.append(title)
                            self.nameArray.append(name)
                            self.moneyArray.append(price)
                            self.locArray.append(place)
                            self.taskArray.append(task)
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
            
            groupNames = groups?.allValues as! [String]
            
            
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let id = UserDefaults.standard.object(forKey: "user_id_taskforce") as! String
        self.getGroups(userId: id)
        loadTables()
        
        
        
    }
    
    
    //loading the table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = self.feedTable.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskFeedCell
        myCell.setInfo(money: moneyArray[indexPath.row], name: nameArray[indexPath.row], task: taskArray[indexPath.row], loc: locArray[indexPath.row])
        return myCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = taskKeys[indexPath.row]
    }
    
}

