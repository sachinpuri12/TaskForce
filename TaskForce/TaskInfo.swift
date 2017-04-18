//
//  TaskInfo.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TaskInfo: UIViewController {
    
    @IBOutlet weak var Requester: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var paymentText: UILabel!

    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var locationText: UILabel!
    
    @IBOutlet weak var ratingText: UILabel!
    var requestRating: String = ""
    var location: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        let ref = FIRDatabase.database().reference()
        ref.child("tasks/\(selectedTask)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let id = value?["id"] as? String ?? ""
            self.changeRating(id: id)
            
            let name = value?["name"] as? String ?? ""
            let title = value?["title"] as? String ?? ""
            let task = value?["description"] as? String ?? ""
            let place = value?["location"] as? String ?? ""
            let price = value?["tip"] as? Double ?? 0.0
            
            self.Requester.text = name
            self.Description.text = task
            self.locationText.text = place
            
            self.paymentText.text = "$" + String(format: "%.2f", price)
            
            
        })
        
    }
    
    func changeRating(id: String) {
        let usersRef = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users")
 
        usersRef.queryOrdered(byChild: "FBId").queryEqual(toValue: "\(id)")
            .observeSingleEvent(of: .value, with: { snapshot in
                
                let innerValue = snapshot.value as? NSDictionary
                let userId = (innerValue?.allKeys[0] as! String)
                self.getRating(userId: userId)
            
    
        })
    
        
    }
    
    func getRating(userId: String){
        let ref = FIRDatabase.database().reference()
        ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.ratingText.text = String(value?["posterRating"] as? Int ?? 1) + "/5"
            

        })
    }
    
            
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

