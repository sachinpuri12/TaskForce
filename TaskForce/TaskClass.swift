//
//  TaskClass.swift
//  TaskForce
//
//  Created by Sachin Puri on 3/27/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit



class Task {
    
    var id:Int
    var posterId:Int
    var taskerId:Int
    var groupId:Int
    var name:String
    var description:String
    var location:String
    var price:Int
    var tip:Int
    var receiptImage:UIImage?
    var status:String
    
    init(id:Int, posterId:Int, taskerId:Int, groupId:Int, name:String, description:String, location:String, price:Int, tip:Int, status:String){
        self.id = id
        self.posterId = posterId
        self.taskerId = taskerId
        self.groupId = groupId
        self.name = name
        self.description = description
        self.location = location
        self.price = price
        self.tip = tip
        self.status = status
    }
    

}
