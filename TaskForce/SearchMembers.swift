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
    
    var usernameArray = [String]()
    var keyArray = [String]()
    var db: FIRDatabaseReference!
   
    @IBOutlet var searchTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTable.delegate = self
        searchTable.dataSource = self
        db = FIRDatabase.database().reference()
        getUsernamesKeys()
    }
    
    func getUsernamesKeys(){
        let ref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users")
        ref.queryOrderedByKey().observe(.childAdded, with: { snapshot in
    
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                self.keyArray.append(snapshot.key)
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    if (rest.key == "username"){
                        self.usernameArray.append(rest.value as! String)
                    }
                }
                self.searchTable.reloadData()
            }
        });
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
        return usernameArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.searchTable.dequeueReusableCell(withIdentifier: "SearchMemberCell", for: indexPath) as! SearchMemberCell
        
        myCell.setInfo(name: usernameArray[indexPath.row], key: keyArray[indexPath.row], inGroup: false)
        myCell.setLabels()
        return myCell
    }
//
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
//
    
}
