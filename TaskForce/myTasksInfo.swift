//
//  myTasksInfo.swift
//  TaskForce
//
//  Created by Sachin Puri on 4/19/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyTaskInfo: UIViewController{
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var paymentText: UILabel!
    @IBOutlet weak var Requester: UILabel!
    
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    var requestRating: String = ""
    var location: String = ""
    
    var taskStatus = String()
    var pickerTag = Int()
    var taskKey = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ref = FIRDatabase.database().reference()
        ref.child("tasks/\(taskKey)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            
            let id = UserDefaults.standard.object(forKey: "user_id_taskforce") as! String
            self.getRating(userId: id)
            
            let name = value?["name"] as? String ?? ""
            let title = value?["title"] as? String ?? ""
            let task = value?["description"] as? String ?? ""
            let place = value?["location"] as? String ?? ""
            let price = value?["tip"] as? Double ?? 0.0
            
            self.titleText.text = title
            self.Requester.text = name
            self.Description.text = task
            self.locationText.text = place
            self.paymentText.text = "$" + String(format: "%.2f", price)
            
            
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
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
    }
}
