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
import MessageUI

class MyTaskInfo: UIViewController, MFMessageComposeViewControllerDelegate{

    @IBOutlet weak var Requester: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var paymentText: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    
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
        
        if pickerTag == 1{
            
            // running accepted
            
            
            // complete task button
            // message poster button
            
        }
        
        else if pickerTag == 2 {
            
            if taskStatus == "requested"{
                    // cancel button
                    // hide message poster button
                    completeButton.setTitle("Cancel Task", for: .normal)
                    messageButton.isHidden = true
            }
            
            else if taskStatus == "accepted"{
                    // hide complete button
                    // message RUNNER button
                    completeButton.isHidden = true
                    messageButton.setTitle("Message TaskRunner", for: .normal)
                
                // ADD TASK RUNNER LABEL
                
            }
            
        }
        
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
        if completeButton.currentTitle == "Complete Task" {
            // ADD INVOICE RECEIPT HERE
            let ref = FIRDatabase.database().reference()
            ref.child("tasks/\(taskKey)").updateChildValues(["status": "completed"])
            
            // alert for fields not filled
            let alert = UIAlertController(title: "Completed!", message: "Thank You! The requester will be notified! Please upload invoice!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.taskStatus = "completed"
            
        }
        else if completeButton.currentTitle == "Cancel Task"{
            let ref = FIRDatabase.database().reference()
            ref.child("tasks/\(taskKey)").removeValue()
            let _ = self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func messageButtonPressed(_ sender: Any) {
        let messageVC = MFMessageComposeViewController()
        messageVC.messageComposeDelegate = self
        
        messageVC.recipients = ["6267103370"]
        messageVC.body = "What's good"
    }

    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)}
}
