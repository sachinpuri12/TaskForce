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
class TaskFeed: UITableViewController {
    
    
    @IBOutlet var feedTable: UITableView!
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
        
        print("indexpath " + String(indexPath.section))
    
//        myCell.backgroundColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.89, alpha: 1)
//        myCell.layer.borderWidth = 1
//        myCell.layer.masksToBounds = false
//        myCell.layer.borderColor = (UIColor.clear).cgColor
//        myCell.layer.borderWidth = 1
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
//        cell.layer.shadowColor = (UIColor(colorLiteralRed: 0.22, green: 0.23, blue: 0.26, alpha: 1)).cgColor
//        cell.layer.shadowOpacity = 0.3
//        cell.layer.shadowRadius = 2
//        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = taskKeys[indexPath.section]
    }
    
}

