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

    @IBOutlet weak var runTable: UITableView!
    @IBOutlet weak var runText: UITextField!
    @IBOutlet weak var runPicker: UIPickerView!
    @IBOutlet weak var requestText: UITextField!
    @IBOutlet weak var requestPicker: UIPickerView!
    @IBOutlet weak var requestTable: UITableView!
    
    var runSort = ["All","Accepted", "Completed"]
    var requestSort = ["All", "Requested", "Requested and Accepted", "Requested and Completed"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows: Int = runSort.count
        if pickerView == requestPicker {
            
            countRows = self.requestSort.count
        }
        
        return countRows
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
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return nameArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let myCell = self.feedTable.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskFeedCell
//        myCell.setInfo(money: moneyArray[indexPath.row], name: nameArray[indexPath.row], task: taskArray[indexPath.row], loc: locArray[indexPath.row])
//        return myCell
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.clear
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedTask = taskKeys[indexPath.row]
//    }

    
}

