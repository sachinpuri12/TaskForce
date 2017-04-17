//
//  GroupMembers.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Members: UITableViewController {
    
    var groupName: String = ""
    var groupKey: String = ""
    var db: FIRDatabaseReference!
    var memberArray = [String]()
    var imageArray = [UIImage]()

    @IBOutlet var memberTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberTable.delegate = self
        memberTable.dataSource = self
        db = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.memberArray.removeAll()
        self.fillMemberTable()
        navigationItem.title = nil
        navigationItem.hidesBackButton = false
        self.title = self.groupName
        
    }
    
    func fillMemberTable(){
        self.memberArray.removeAll()
        
        let groupID = groupKey
        let newref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/groups/\(groupID)")
        newref.child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    self.memberArray.append(rest.value! as! String)
                    //self.keyArray.append(rest.key)
                }
                self.memberTable.reloadData()
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //fillGroupTable()
        super.viewDidAppear(animated)
        memberTable.reloadData()
    }
    
    
    
    //loading the table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.memberTable.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        
        myCell.setMemberName(name: memberArray[indexPath.row])
        return myCell
    }
    
    @IBAction func addMember(_ sender: Any) {
        self.performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        //let nav = segue.destination as!UINavigationController
        let searchMember = segue.destination as! SearchMembers
            
        searchMember.groupKey = groupKey
        
        searchMember.groupName = groupName
        
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
}

