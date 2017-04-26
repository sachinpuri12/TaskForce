//
//  FormViewController.swift
//  TaskForce
//
//  Created by Jimmy Carney on 4/25/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    @IBOutlet weak var ChargeAmount: UITextField!
    @IBOutlet weak var VenmoNote: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        ChargeAmount.keyboardType = .decimalPad
        VenmoNote.keyboardType = .asciiCapable
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
