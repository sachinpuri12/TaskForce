//
//  SearchMembers.swift
//  TaskForce
//
//  Created by Rexi Sheredy on 4/10/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchMembers: UITableViewController {
    
    let testArray = ["test1", "test2", "test3"]

    @IBOutlet var searchTable: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTable.delegate = self
        searchTable.dataSource = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTable.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.searchTable.dequeueReusableCell(withIdentifier: "SearchMemberCell", for: indexPath) as! SearchMemberCell
        
        myCell.setMemberName(name: testArray[indexPath.row])
        return myCell
    }
//
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
//
    
}
