//
//  TaskFeedCell.swift
//  TaskForce
//
//  Created by Rexi Sheredy on 3/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit

class GroupsCell: UITableViewCell {
    
   
    @IBOutlet weak var groupName: UILabel!
    var groupKey: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setGroupName(name: String){
        groupName.text = name
    }
    
    func setGroupKey(key: String){
        self.groupKey = key
    }
}
