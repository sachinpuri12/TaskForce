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
    
    
    var taskStatus = String()
    var pickerTag = Int()
    var taskKey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
