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
    @IBOutlet weak var greenView: UIView!

    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var requesterImage: UIImageView!
    
    @IBOutlet weak var locationText: UILabel!
    
    @IBOutlet weak var ratingText: UILabel!
    var requestRating: String = ""
    var location: String = ""
    
    @IBAction func AcceptTask(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        ref.child("tasks/\(selectedTask)").updateChildValues(["status": "accepted"])
        ref.child("tasks/\(selectedTask)").updateChildValues(["acceptor": globalUser])
    }
    override func viewWillAppear(_ animated: Bool) {
        let ref = FIRDatabase.database().reference()
        ref.child("tasks/\(selectedTask)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            
            let id = UserDefaults.standard.object(forKey: "user_id_taskforce") as! String
            self.getRating(userId: id)
            let requester = value?["id"] as? String ?? ""
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
            
            
            if !(requester==""){
                print("got here")
                self.setImage(profileID: requester)
            }
            
            self.requesterImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.requesterImage.layer.cornerRadius = self.requesterImage.frame.size.width / 2
            self.requesterImage.layer.borderColor = UIColor(colorLiteralRed: 0.98, green:0.63, blue:0.11, alpha:1.0).cgColor
            self.requesterImage.layer.borderWidth = 3
            self.requesterImage.clipsToBounds = true
            
            let test = UIView(frame: CGRect(x: 0, y: self.greenView.layer.bounds.height-1.5, width: self.greenView.layer.bounds.width, height: 3))
            test.backgroundColor = UIColor(colorLiteralRed: 0.98, green:0.63, blue:0.11, alpha:1.0)
            self.greenView.addSubview(test)
            
            self.taskView.backgroundColor = UIColor(colorLiteralRed: 0.96, green: 0.96, blue: 0.96, alpha: 1)
            let shadowPath = UIBezierPath(rect: CGRect(x: 1, y: 1, width: self.taskView.layer.bounds.width, height: self.taskView.layer.bounds.height))
            self.taskView.layer.masksToBounds = false
            self.taskView.layer.shadowColor = UIColor.darkGray.cgColor
            self.taskView.layer.shadowOffset = CGSize(width: 2, height: 3)
            self.taskView.layer.shadowOpacity = 0.5
            self.taskView.layer.shadowPath = shadowPath.cgPath

            self.paymentText.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
            self.paymentText.layer.cornerRadius = self.paymentText.frame.size.width/2
            self.paymentText.layer.masksToBounds = true
            self.paymentText.layer.borderWidth = 3
            self.paymentText.layer.borderColor = (UIColor(colorLiteralRed: 0.31, green: 0.36, blue: 0.4, alpha: 1)).cgColor
            
    
            self.acceptButton.layer.cornerRadius = 8
            self.acceptButton.layer.masksToBounds = true
            

        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setImage(profileID: String){
        if let url = NSURL(string: "https://graph.facebook.com/"+profileID+"/picture?type=large&return_ssl_resources=1") {
            if let data = NSData(contentsOf: url as URL) {
                self.requesterImage.image = resizeImage(image: UIImage(data: data as Data)!, toTheSize:CGSize(width:80, height: 80))
            }        
        }
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        let scale = CGFloat(max(size.width/image.size.width, size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale
        
        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
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

