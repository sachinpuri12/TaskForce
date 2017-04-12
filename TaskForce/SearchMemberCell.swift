//
//  SearchMemberCell.swift
//  TaskForce
//
//  Created by Rexi Sheredy on 4/10/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit
class SearchMemberCell: UITableViewCell {
    
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setMemberName(name: String){
        memberName.text = name
        
    }
    
}
