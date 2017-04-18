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
    var isAdmin: Bool = false
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addRemoveButton: UIButton!
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        profileImage.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
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
    
    func currUserIsAdmin(){
        self.isAdmin = true
    }
    
    func changeButton(){
        if (self.isAdmin){
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
        else{
            if (self.inGroup) {
                addRemoveButton.backgroundColor = UIColor.blue
                addRemoveButton.layer.cornerRadius = 5
                addRemoveButton.setTitle("  Added  ", for: UIControlState.normal)
            }
            else{
                addRemoveButton.backgroundColor = UIColor.green
                addRemoveButton.layer.cornerRadius = 5
                addRemoveButton.setTitle("  Add  ", for: UIControlState.normal)
            }

        }
    }
    
    @IBAction func addRemoveMember(_ sender: Any) {
        if(self.isAdmin){
            if (self.inGroup){
                self.inGroup = false
                removeMember()
                changeButton()
            }
            else{
                self.inGroup = true
                addMember()
                changeButton()
            }
        }
        else{
            self.inGroup = true
            addMember()
            changeButton()
        }
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
    
    func setImage(profile: UIImage){
        
        let newImage = resizeImage(image: profile, toTheSize: CGSize(width: 60, height: 60))
        profileImage.image = newImage
        
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        let scale = CGFloat(max(size.width/image.size.width, size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale
        
        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    
}
