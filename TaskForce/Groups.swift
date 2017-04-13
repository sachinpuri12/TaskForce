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


class Groups: UITableViewController {
    
    var groupArray = [String]()
    var keyArray = [String]()
    var db: FIRDatabaseReference!
    var currentUsername = ""
    
    @IBOutlet var groupsTable: UITableView!
    
    
    @IBAction func addNewGroup(_ sender: Any) {
        let userId = (UserDefaults.standard.value(forKey: "user_id_taskforce")) as! String
        let newref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users/\(userId)")
        newref.child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            self.currentUsername = snapshot.value! as! String
        })
        
        let alert = UIAlertController(title: "Add new group", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            let textField = alert?.textFields![0]
            let newGroupName = textField?.text
            if (newGroupName == ""){
                let alert2 = UIAlertController(title: "Error", message: "Please add a group name", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert2, animated: true, completion: nil)
            }
            else{
                let userId = (UserDefaults.standard.value(forKey: "user_id_taskforce")) as! String
                self.addNewGroupToDB(newGroupName: newGroupName!, userID: userId)
                self.fillGroupTable()
                self.groupsTable.reloadData()
            }
        }))
        
        self.present(alert, animated: true, completion: nil)

    }    
    
    func addNewGroupToDB(newGroupName: String, userID: String){
        let newGroup = [
            "name": newGroupName,
            "members": [
                (UserDefaults.standard.value(forKey: "user_id_taskforce")! as! String): self.currentUsername] as [String: Any]
            ] as [String: Any]

        //adding to the group database

        let ref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/groups")
        let newGroupRef = ref.childByAutoId()
        
        newGroupRef.setValue(newGroup)
        let newGroupID = newGroupRef.key
        addNewGroupToUser(newGroupID: newGroupID, userID: userID, newGroupName: newGroupName)
    }
    
    func addNewGroupToUser(newGroupID: String, userID: String, newGroupName: String){
        //adding groupID to the user database
        FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users/\(userID)/groups").child(newGroupID).setValue(newGroupName)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //groupsTable.delegate = self
        //groupsTable.dataSource = self
        db = FIRDatabase.database().reference()
        //fillGroupTable()
    }
    
    func fillGroupTable(){
        self.groupArray.removeAll()
        self.keyArray.removeAll()
        let userId = (UserDefaults.standard.value(forKey: "user_id_taskforce")) as! String
        let newref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users/\(userId)")
        newref.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    self.groupArray.append(rest.value! as! String)
                    self.keyArray.append(rest.key)
                }
                self.groupsTable.reloadData()
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //fillGroupTable()
        super.viewDidAppear(animated)
        groupsTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        fillGroupTable()
        groupsTable.reloadData()
    }

    
    //loading the table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.groupsTable.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsCell
        
        myCell.setGroupName(name: groupArray[indexPath.row])
        myCell.setGroupKey(key: keyArray[indexPath.row])
        myCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    //pushing to next screen when something is clicked
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedGroupName = self.groupArray[indexPath.row]
//        selectedGroupKey = self.keyArray[indexPath.row]
        // Segue to the second view controller
        self.performSegue(withIdentifier: "memberView", sender: self)
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.groupsTable.indexPathForSelectedRow {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
            //let nav = segue.destination as! UINavigationController
            let members = segue.destination as! Members
            
            members.groupName = groupArray[indexPath.row]
            members.groupKey = keyArray[indexPath.row]
            print("groups:" + members.groupName)
        }
    }
    
    
}

