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
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        moneyLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        moneyLabel.layer.cornerRadius = moneyLabel.frame.size.width/2
        moneyLabel.layer.masksToBounds = true
        cellView.layer.masksToBounds = true
        cellView.backgroundColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.89, alpha: 1)
        cellView.layer.masksToBounds = false
        cellView.clipsToBounds = false
        cellView.layer.borderColor = (UIColor.clear).cgColor
        cellView.backgroundColor = UIColor(colorLiteralRed: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        cellView.layer.shadowColor = (UIColor(colorLiteralRed: 0.22, green: 0.23, blue: 0.26, alpha: 1)).cgColor
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowRadius = 2
        cellView.layer.shadowOffset = CGSize(width: 1, height: 1)

        super.awakeFromNib()
        
    }
    
    func setInfo(money: Int, name: String, task: String, loc: String){
        moneyLabel.text = "$" + String(money)
        nameLabel.text = name
        taskLabel.text = "Task: " + task
        locLabel.text = "Location: " + loc
        
    }
    
}
