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

    var requestRating: String = ""
    var location: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        let ref = FIRDatabase.database().reference()
        ref.child("tasks/\(selectedTask)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let name = value?["name"] as? String ?? ""
            
            let title = value?["title"] as? String ?? ""
            let task = value?["description"] as? String ?? ""
            let place = value?["location"] as? String ?? ""
            let price = value?["tip"] as? String ?? ""
            
            self.Requester.text = name
            self.Description.text = task
            self.paymentText.text = price
            
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

