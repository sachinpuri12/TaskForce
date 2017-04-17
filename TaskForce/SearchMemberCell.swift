//
//  SearchMemberCell.swift
//  TaskForce
//
//  Created by Rexi Sheredy on 4/10/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit
import Firebase

class SearchMemberCell: UITableViewCell {
    
    var name: String = ""
    var key: String = ""
    var inGroup: Bool = false
    var groupKey: String = ""
    var groupName: String = ""
    var db: FIRDatabaseReference!
    
    @IBOutlet weak var addRemoveButton: UIButton!
    
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setInfo(name: String, key: String, groupKey: String, inGroup: Bool, groupName: String){
        self.name = name
        self.key = key
        self.inGroup = inGroup
        self.groupKey = groupKey
        self.groupName = groupName
        db = FIRDatabase.database().reference()
        
        changeButton()
    }
    
    func changeButton(){
        if (self.inGroup) {
            addRemoveButton.backgroundColor = UIColor.red
            addRemoveButton.layer.cornerRadius = 5
            addRemoveButton.setTitle("  Remove  ", for: UIControlState.normal)
        }
        else{
            addRemoveButton.backgroundColor = UIColor.green
            addRemoveButton.layer.cornerRadius = 5
            addRemoveButton.setTitle("  Add  ", for: UIControlState.normal)
        }
    }
    
    @IBAction func addRemoveMember(_ sender: Any) {
        if (self.inGroup){
            self.inGroup = false
            removeMember()
        }
        else{
            self.inGroup = true
            addMember()

        }
        
        changeButton()
        
    }
    
    func addMember(){
        FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users/\(self.key)/groups").child(self.groupKey).setValue(self.groupName)
        FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/groups/\(self.groupKey)/members").child(self.key).setValue(self.name)
        
    }
    
    func removeMember(){
        FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users/\(self.key)/groups").child(self.groupKey).removeValue()
        FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/groups/\(self.groupKey)/members").child(self.key).removeValue()
    }
    
    func setLabels(){
        memberName.text = self.name
    }
    
}
