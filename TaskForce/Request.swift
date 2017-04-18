//
//  TaskRequest.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var groups = [String]()
class TaskRequest: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var cost: UITextField!

    @IBOutlet weak var group: UITextField!
    @IBOutlet weak var taskType: UITextField!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var taskTypePicker: UIPickerView!
    
    var db: FIRDatabaseReference!
    var taskTypes = ["Grocery", "Home-Based", "Shopping", "Other"]
    
    var groupIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = FIRDatabase.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let groupsRef = db.child("groups")
        groupsRef.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                let groupID = (child as AnyObject).key!
                self.groupIDs.append(groupID)
            }
            self.displayArray(name: self.groupIDs) //print out groupIDS array
      
            for item in self.groupIDs{
                self.db.child("groups/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let groupName = value["name"] as? String ?? ""
                        groups.append(groupName)
                        self.setDelegateDataSource()
                    }
                })
            }
            self.displayArray(name: groups) //print out groups array
        })
    }

    func setDelegateDataSource(){
        
        self.groupPicker.delegate = self
        self.groupPicker.dataSource = self
        self.groupPicker.reloadAllComponents()
        self.taskTypePicker.delegate = self
        self.taskTypePicker.dataSource = self
        self.taskTypePicker.reloadAllComponents()
        
    }
    
    func displayArray(name: [String]) {
        for i in name{
            print(i)
        }
        print(name.count)
    }
    
    @IBAction func requestTaskInsertDatabase(_ sender: Any) {
        
        if ((taskTitle.text?.isEmpty)! || (location.text?.isEmpty)! || (cost.text?.isEmpty)!) {
            
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure all fields are filled!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else {
            
            // push new task to database
            let newTask = [
                "name": globalUser as Any,
                "id": globalId as Any,
                "title": taskTitle.text as Any,
                "description": taskDescription.text as Any,
                "location": location.text as Any,
                "price": 0.00,
                "tip": Double(cost.text!) as Any,
                "status": String("requested") as Any,
                "group": group.text as Any
                ] as [String: Any]
            // FIXME make price and tip decimal format
            
            self.db.child("tasks").childByAutoId().setValue(newTask)
            
            // alert for SUCCESS
            let alert = UIAlertController(title: "Task Posted!", message: "You will be notified when a user accepts.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows: Int = self.taskTypes.count
        if pickerView == groupPicker {
            countRows = groups.count
        }
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
      
        if pickerView == groupPicker {
            let titleRow = groups[row]
            return titleRow
        }
        else if pickerView == taskTypePicker{
            let titleRow = taskTypes[row]
            return titleRow
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == groupPicker {
            self.group.text = groups[row]
            //self.runPicker.isHidden = true
            self.group.endEditing(true)
        }
            
        else if pickerView == taskTypePicker{
            self.taskType.text = self.taskTypes[row]
            //            self.requestPicker.isHidden = true
            self.taskType.endEditing(true)
            
        }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.groupPicker){
            self.groupPicker.isHidden = false
            
        }
        else if (textField == self.taskTypePicker){
            self.taskTypePicker.isHidden = false
            
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


