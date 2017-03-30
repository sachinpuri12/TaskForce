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
    var db: FIRDatabaseReference!
    let nameArray = ["Rexi", "David"]
    let taskArray = ["Get eggs", "Paint fence"]
    let locArray = ["Schnucks", "Beta"]
    let moneyArray = [1, 10]
    var tasksArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.delegate = self
        feedTable.dataSource = self
        db = FIRDatabase.database().reference()
        let ref = FIRDatabase.database().reference()
        let taskRef = ref.child("tasks")
        
        taskRef.observeSingleEvent(of: .value, with: { snapshot in
            print("HelLOooooooooOOOooooOOOOOOoooo")
            
            for child in snapshot.children{
                //let snap = child as! FIRDataSnapshot
                //let name = snap["name"].value
                //print(name)
                
            }
            
            if snapshot.hasChild("-KgQs-SuwobapIwuelXw"){
                print("we got kids fam")
            }
            else{
                print("das a no")
            }
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feedTable.reloadData()
        super.viewDidLoad()
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
    
}

