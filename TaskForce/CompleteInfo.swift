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
    
    var requestRating: String = ""
    var location: String = ""
    
    override func viewDidLoad() {
        print("we in here COMPLETED bitches")
        let ref = FIRDatabase.database().reference()
        ref.child("tasks/\(globalMyTaskKey)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                let value = snapshot.value as? NSDictionary
                let requester = value?["id"] as? String ?? ""
                //self.getRating(userId: requester)
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
                    print("we in here")
                    self.setImage(profileID: requester)
                }
            }
        })

        super.viewDidLoad()
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
    
    

    
}
