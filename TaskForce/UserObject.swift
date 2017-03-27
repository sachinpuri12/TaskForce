//
//  UserObject.swift
//  TaskForce
//
//  Created by David Lee-Tolley on 3/27/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var id:Int
    var username:String
    var password:String
    var posterRating:Double
    var totalPosts:Int
    var taskerRating:Double
    var totalTasks:Int
    var address:String
    var phoneNumber:String
    
    init (id:Int, username:String, password:String, posterRating:Double, totalPosts:Int, taskerRating:Double, totalTasks:Int, address:String, phoneNumber:String) {
        
        self.id = id
        self.username = username
        self.password = password
        self.posterRating = posterRating
        self.totalPosts = totalPosts
        self.taskerRating = taskerRating
        self.totalTasks = totalTasks
        self.address = address
        self.phoneNumber = phoneNumber
        
    }
    
}
