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


class TaskFeed: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTable: UITableView!
    let nameArray = ["Rexi", "David", "Sachin", "Jimmy"]
    let taskArray = ["Get eggs", "Paint fence", "Wash dishes", "Pick up dry cleaning"]
    let locArray = ["Schnucks", "Beta", "Beta", "Dry Cleaners"]
    let moneyArray = [1, 10, 4, 2]
    var db = FIRDatabase.database().reference()
    var tasksArray = [Task]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.delegate = self
        feedTable.dataSource = self
        db = FIRDatabase.database().reference()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feedTable.reloadData()
        super.viewDidLoad()
        db = FIRDatabase.database().reference()
    }
//    func loadData(){
//        let snap = db.observeSingleEventOfType(.value, withBlock: { snapshot in
//            
//            if !snapshot.exists() { return }
//            
//            //print(snapshot)
//            
//            if let userName = snapshot.value["full_name"] as? String {
//                print(userName)
//            }
//            if let email = snapshot.value["email"] as? String {
//                print(email)
//            }
//            
//            // can also use
//            // snapshot.childSnapshotForPath("full_name").value as! String
//        })
//    }

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
    
}

