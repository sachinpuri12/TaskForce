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
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var cost: UITextField!

    @IBOutlet weak var taskDescription: UITextField!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var taskTypePicker: UIPickerView!
    
    //UI Views for Interface
    @IBOutlet weak var titleLabelView: UIView!
    @IBOutlet weak var detailLabelView: UIView!
    @IBOutlet weak var locLabelView: UIView!
    @IBOutlet weak var tipLabelView: UIView!
    @IBOutlet weak var typeLabelView: UIView!
    @IBOutlet weak var groupLabelView: UIView!
    
    @IBOutlet weak var acceptButton: UIButton!
    var viewArray = [UIView]()
    
    var group: String = ""
    var taskType: String = ""
    
    var db: FIRDatabaseReference!
    var taskTypes = ["Grocery", "Home-Based", "Shopping", "Other"]
    var groupNamesPicker = [String]()
    var userKeys = [String]()
    
//    var groupIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = FIRDatabase.database().reference()
        // Do any additional setup after loading the view, typically from a nib.
        setUserKeyIfNil()
        let id = UserDefaults.standard.object(forKey: "user_id_taskforce") as! String
            print(id)
        self.getGroups(userId: id)
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor(colorLiteralRed: 0.18, green: 0.24, blue: 0.28, alpha: 1)
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor(colorLiteralRed: 0.75, green: 0.75, blue: 0.75, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let id = UserDefaults.standard.object(forKey: "user_id_taskforce") as! String
        self.getGroups(userId: id)
        
        viewArray = [titleLabelView,  detailLabelView, locLabelView,  tipLabelView, typeLabelView,  groupLabelView]
        
        for view in viewArray{
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.89, alpha: 1).cgColor
            view.layer.cornerRadius = 8
        }
        groupPicker.showsSelectionIndicator = false
        
        acceptButton.layer.cornerRadius = 8
    }

    func setDelegateDataSource(){
        
        self.groupPicker.delegate = self
        self.groupPicker.dataSource = self
        self.groupPicker.reloadAllComponents()
        self.taskTypePicker.delegate = self
        self.taskTypePicker.dataSource = self
        self.taskTypePicker.reloadAllComponents()
        
    }
    
    func getGroups(userId: String){
        print(userId)
        let ref = FIRDatabase.database().reference()
        ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let groups = (value?["groups"] as? NSDictionary)
            if (groups == nil){
                let alert = UIAlertController(title: "No Groups!", message: "You must have groups to request a task!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.groupNamesPicker = [""]
                self.present(alert, animated: true, completion: nil)
            }
            else{
                self.groupNamesPicker = groups?.allValues as! [String]
            }
            print(self.groupNamesPicker)
            self.setDelegateDataSource()
            
        })
    }

    @IBAction func taskRequested(_ sender: Any) {
        
        if ((taskTitle.text?.isEmpty)! || (location.text?.isEmpty)! || (cost.text?.isEmpty)!) {
            
            // alert for fields not filled
            let alert = UIAlertController(title: "Error", message: "Please make sure all fields are filled!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if (self.groupNamesPicker == [""]){
            let alert = UIAlertController(title: "Error", message: "You are not in any groups! Please add groups from the Groups Tab before requesting a task.", preferredStyle: UIAlertControllerStyle.alert)
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
                "group": group as Any,
                "acceptor": String("null") as Any,
                "type": taskType as Any
                ] as [String: Any]
            // FIXME make price and tip decimal format
            
            self.db.child("tasks").childByAutoId().setValue(newTask)
            
            // alert for SUCCESS
            let alert = UIAlertController(title: "Task Posted!", message: "You will be notified when a user accepts.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.resignFirstResponder()
        return false
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRows: Int = self.taskTypes.count
        if pickerView == groupPicker {
            countRows = groupNamesPicker.count
        }
        return countRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
      
        if pickerView == groupPicker {
            let titleRow = groupNamesPicker[row]
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
            self.group = groupNamesPicker[row]
            //self.runPicker.isHidden = true
            //self.group.endEditing(true)
        }
            
        else if pickerView == taskTypePicker{
            self.taskType = self.taskTypes[row]
            //            self.requestPicker.isHidden = true
            //self.taskType.endEditing(true)
            
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
    
    func setUserKeyIfNil(){
        
        if UserDefaults.standard.object(forKey: "user_id_taskforce") as? String == nil{
            let ref = FIRDatabase.database().reference()
            let usersRef = ref.child("users")
            usersRef.observeSingleEvent(of: .value, with: { snapshot in
                self.userKeys.removeAll()
                for child in snapshot.children{
                    let userID = (child as AnyObject).key!
                    self.userKeys.append(userID)
                }
                print(self.userKeys)
                for item in self.userKeys{
                    ref.child("users/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let username = value?["username"] as? String ?? ""
                        print(globalUser)
                        print(globalId)
                        if username == globalUser {
                            print(username)
                            print(item)
                            UserDefaults.standard.set(item, forKey: "user_id_taskforce")
                        }
                    })
                }
            })
        }
    }
    
    
}


