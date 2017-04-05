//
//  TaskFeedCell.swift
//  TaskForce
//
//  Created by Rexi Sheredy on 3/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit

class TaskFeedCell: UITableViewCell {
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setInfo(money: Int, name: String, task: String, loc: String){
        moneyLabel.text = "$" + String(money)
        nameLabel.text = "Name: " + name
        taskLabel.text = "Task: " + task
        locLabel.text = "Location: " + loc
    }
    
}
