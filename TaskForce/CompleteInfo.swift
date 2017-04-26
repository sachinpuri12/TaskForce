//
//  CompleteInfo.swift
//  TaskForce
//
//  Created by Sachin Puri on 4/19/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase



class CompleteInfo: UIViewController{
    
    @IBOutlet weak var Requester: UILabel!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var invoiceImage: UIImageView!
    @IBOutlet weak var paymentText: UILabel!
    @IBOutlet weak var requesterImage: UIImageView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var taskView: UIView!
    
    @IBOutlet weak var rating: CosmosView!
    var requestRating: String = ""
    var location: String = ""
    
    override func viewWillAppear(_ animated: Bool){
        //print("we in here COMPLETED bitches")
        let ref = FIRDatabase.database().reference()
        ref.child("tasks/\(globalMyTaskKey)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                let value = snapshot.value as? NSDictionary
                let requester = value?["id"] as? String ?? ""
                self.getRating(userId: requester)
                let name = value?["name"] as? String ?? ""
                let title = value?["title"] as? String ?? ""
                let task = value?["description"] as? String ?? ""
                let place = value?["location"] as? String ?? ""
                let price = value?["tip"] as? Double ?? 0.0
                
                //GET and DISPLAY RECEIPT IMAGE HERE
                self.titleText.text = title
                self.Requester.text = name
                self.Description.text = task
                self.locationText.text = place
                self.paymentText.text = "$" + String(format: "%.2f", price)
                
                if !(requester==""){
                    //print("we in here")
                    self.setImage(profileID: requester)
                }
            }
            let test = UIView(frame: CGRect(x: 0, y: self.greenView.layer.bounds.height-1.5, width: self.greenView.layer.bounds.width, height: 3))
            //print(self.greenView.layer.bounds.width)
            test.backgroundColor = UIColor(colorLiteralRed: 0.98, green:0.63, blue:0.11, alpha:1.0)
            self.greenView.addSubview(test)
            
            self.taskView.backgroundColor = UIColor(colorLiteralRed: 0.96, green: 0.96, blue: 0.96, alpha: 1)

            

        })

    }
    
    override func viewDidLoad() {
        self.requesterImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.requesterImage.layer.cornerRadius = self.requesterImage.frame.size.width / 2
        self.requesterImage.layer.borderColor = UIColor(colorLiteralRed: 0.98, green:0.63, blue:0.11, alpha:1.0).cgColor
        self.requesterImage.layer.borderWidth = 3
        self.requesterImage.clipsToBounds = true
    
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let shadowPath = UIBezierPath(rect: CGRect(x: 1, y: 1, width: self.taskView.layer.bounds.width, height: self.taskView.layer.bounds.height))
        self.taskView.layer.shadowColor = UIColor.darkGray.cgColor
        self.taskView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.taskView.layer.shadowOpacity = 0.5
        self.taskView.layer.shadowPath = shadowPath.cgPath
        self.taskView.layer.masksToBounds = false

        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //let ref = FIRDatabase.database().reference()
        let usersRef = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users")
        
        usersRef.queryOrdered(byChild: "FBId").queryEqual(toValue: "\(userId)")
            .observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? NSNull {
                    return
                } else {
                    for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        for test in rest.value as! NSDictionary{
                            if (String(describing: test.key) == "posterRating"){
                                print(test.value)
                                self.rating.settings.filledColor = UIColor(red:0.98, green:0.63, blue:0.11, alpha:1.0)
                                // Set the border color of an empty star
                                self.rating.settings.emptyBorderColor = UIColor(red:0.98, green:0.63, blue:0.11, alpha:1.0)
                                self.rating.settings.fillMode = .precise
                                // Set the border color of a filled star
                                self.rating.settings.filledBorderColor = UIColor(red:0.98, green:0.63, blue:0.11, alpha:1.0)
                                self.rating.settings.updateOnTouch = false
                                self.rating.rating = test.value as! Double
                            }
                        }
                    }
                    
                }
                
            })
        
        
    }

    
}
