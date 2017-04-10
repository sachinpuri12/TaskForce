//
//  Profile.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit


class MyTasks: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var runningTaskSortText: UITextField!
    @IBOutlet weak var runningTaskSortPicker: UIPickerView!
    
    var runSort = ["Accepted", "Completed"]
    var requestSort = ["Requested", "Requested and Accepted", "Requested and Completed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        runningTaskSortPicker.delegate = self
        runningTaskSortPicker.dataSource = self
        runningTaskSortText.inputView = runningTaskSortPicker
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return runSort.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return runSort[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        runningTaskSortText.text = runSort[row]
        self.runningTaskSortPicker.isHidden = true
        
    }
    
    
}

