//
//  UserObject.swift
//  TaskForce
//
//  Created by David Lee-Tolley on 3/27/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit

class Group {
    
    var id:Int
    var name:String
    var members:[String]
    
    init (id:Int, name:String, members:[String]) {
        
        self.id = id
        self.name = name
        self.members = members
        
    }
    
}
