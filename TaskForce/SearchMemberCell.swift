//
//  SearchMemberCell.swift
//  TaskForce
//
//  Created by Rexi Sheredy on 4/10/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit
class SearchMemberCell: UITableViewCell {
    
    var name: String = ""
    var key: String = ""
    var inGroup: Bool = false
    var groupKey: String = ""
    
    @IBOutlet weak var addRemoveButton: UIButton!
    
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setInfo(name: String, key: String, groupKey: String, inGroup: Bool){
        self.name = name
        self.key = key
        self.inGroup = inGroup
        self.groupKey = groupKey
        
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
    
    func setLabels(){
        memberName.text = self.name
    }
    
}
