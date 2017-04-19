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
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var paymentText: UILabel!
    @IBOutlet weak var Requester: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
