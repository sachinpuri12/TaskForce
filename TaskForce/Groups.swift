//
//  TaskFeed.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit


class Groups: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let groupArray = ["Volleyball", "Beta", "Apartment 6623"]
    
    @IBOutlet weak var groupsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsTable.delegate = self
        groupsTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        groupsTable.reloadData()
    }
    
    //loading the table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.groupsTable.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsCell
        myCell.setGroupName(name: groupArray[indexPath.row])
        return myCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}

