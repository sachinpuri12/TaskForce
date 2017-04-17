//
//  Profile.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit


class MyTasks: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var runText: UITextField!
    @IBOutlet weak var runPicker: UIPickerView!
    @IBOutlet weak var requestText: UITextField!
    @IBOutlet weak var requestPicker: UIPickerView!
    
    var runSort = ["All","Accepted", "Completed"]
    var requestSort = ["All", "Requested", "Requested and Accepted", "Requested and Completed"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countrows: Int = runSort.count
        if pickerView == requestPicker {
            
            countrows = self.requestSort.count
        }
        
        return countrows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == runPicker {
            
            let titleRow = runSort[row]
            
            return titleRow
            
        }
            
        else if pickerView == requestPicker{
            let titleRow = requestSort[row]
            
            return titleRow
        }
        
        return ""
    }

    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == runPicker {
            self.runText.text = self.runSort[row]
            //self.runPicker.isHidden = true
            self.runText.endEditing(true)
        }
            
        else if pickerView == requestPicker{
            self.requestText.text = self.requestSort[row]
//            self.requestPicker.isHidden = true
            self.requestText.endEditing(true)
            
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.runText){
            self.runPicker.isHidden = false
            
        }
        else if (textField == self.requestText){
            self.requestPicker.isHidden = false
            
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == self.runText){
            self.runPicker.isHidden = false
            
        }
        else if (textField == self.requestText){
            self.requestPicker.isHidden = false
            
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.runPicker.delegate = self
        self.runPicker.dataSource = self
        self.runPicker.reloadAllComponents()
        self.runText.inputView = runPicker
        self.requestPicker.delegate = self
        self.requestPicker.dataSource = self
        self.requestPicker.reloadAllComponents()
        self.requestText.inputView = requestPicker
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

