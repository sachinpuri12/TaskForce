//
//  TaskRequest.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TaskRequest: UIViewController {

    
    var db: FIRDatabaseReference!

    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var cost: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = FIRDatabase.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func requestTaskInsertDatabase(_ sender: Any) {
        
        if ((taskTitle.text?.isEmpty)! || (location.text?.isEmpty)! || (cost.text?.isEmpty)!) {
            
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure all fields are filled!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else {
            
            // push new task to database
            let newTask = [
                "name": taskTitle.text as Any,
                "description": taskDescription.text as Any,
                "location": location.text as Any,
                "price": 0.00,
                "tip": Double(cost.text!) as Any,
                "status": String("requested") as Any
                ] as [String: Any]
            // FIXME make price and tip decimal format
            
            self.db.child("tasks").childByAutoId().setValue(newTask);
            
            // alert for SUCCESS
            let alert = UIAlertController(title: "Task Posted!", message: "You will be notified when a user accepts.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }

    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


