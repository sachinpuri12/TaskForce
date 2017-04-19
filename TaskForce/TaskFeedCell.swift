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
        super.awakeFromNib()
        
        
        //self.contentView.backgroundColor = UIColor.black
        let test = UIView(frame: CGRect(x: 10, y: 10, width: self.contentView.layer.bounds.width+15, height: self.contentView.layer.bounds.height-15))
//        print(self.cellView.layer.bounds.width)
//        print(self.cellView.layer.bounds.height)
        test.backgroundColor = UIColor(colorLiteralRed: 0.98, green: 0.98, blue: 0.99, alpha: 1)
        let shadowPath = UIBezierPath(rect: CGRect(x: 1, y: 1, width: test.layer.bounds.width, height: test.layer.bounds.height))
        test.layer.masksToBounds = false
        test.layer.shadowColor = UIColor.darkGray.cgColor
        test.layer.shadowOffset = CGSize(width: 2, height: 3)
        test.layer.shadowOpacity = 0.5
        test.layer.shadowPath = shadowPath.cgPath
        
        
            
        self.cellView.insertSubview(test, at: 0)
        self.backgroundColor = UIColor.gray

        
        
    }

    
    func setInfo(money: Int, name: String, task: String, loc: String){
        moneyLabel.text = "$" + String(money)
        nameLabel.text = name
        taskLabel.text = "Task: " + task
        locLabel.text = "Location: " + loc
        
    }
    
}
