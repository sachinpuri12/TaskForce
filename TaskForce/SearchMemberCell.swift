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
    
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setInfo(name: String, key: String, inGroup: Bool){
        self.name = name
        self.key = key
        self.inGroup = inGroup
    }
    
    func setLabels(){
        memberName.text = self.name
        
    }
    
}
