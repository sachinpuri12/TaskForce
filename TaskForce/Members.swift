//
//  GroupMembers.swift
//  TaskForce
//
//  Created by Sachin Puri on 2/22/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase
var globalGroupKey = ""
class Members: UITableViewController {
    
    var groupName: String = ""
    var groupKey: String = ""
    var db: FIRDatabaseReference!
    var memberArray = [String]()
    var memberKeyArray = [String]()
    var imageCache = [String: UIImage]()
    var admin: String = ""

    @IBOutlet var memberTable: UITableView!
    @IBOutlet weak var memberButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if groupKey != ""{
            globalGroupKey = groupKey
        }
        else {
            groupKey = globalGroupKey
        }
       
        //print("groupName:" + groupName)
        //print("groupKey:" + groupKey)
        db = FIRDatabase.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("**********************")
        
        viewDidLoad()
        viewDidAppear(true)

        super.viewWillAppear(true)
        self.memberArray.removeAll()
        self.memberKeyArray.removeAll()
        self.fillMemberTable()
       
        navigationItem.title = nil
        navigationItem.hidesBackButton = false
        self.title = self.groupName
        memberButton.title = "edit"
        
        

    }
    
    func fillMemberTable(){
       print("GROUP KEY:######")
        print(groupKey)
        let groupID = groupKey
        let newref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/groups/\(groupID)")
        newref.child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    
                    self.memberArray.append(rest.value! as! String)
                    
                    self.memberKeyArray.append(rest.key)
                    
                }
            }
            self.getAdmin()
            self.memberTable.reloadData()
            
        })
        
        
        
    }
    
    func getAdmin(){
        let groupID = groupKey
        let newref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/groups/\(groupID)")
        newref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                for rest in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    if (rest.key == "admin"){
                        self.admin = rest.value! as! String
                    }
                }
            }

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       
        super.viewDidAppear(true)
        
    }
 
    
    
    //loading the table
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = self.memberTable.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        
        print("indexPath " + String(indexPath.row))
        
        if (memberKeyArray[indexPath.row] == self.admin){
            myCell.setMemberName(name: (memberArray[indexPath.row] + " 👑"))
        }
        else{
            myCell.setMemberName(name: memberArray[indexPath.row])
        }
        
        
        var urlString: String = ""
        let ref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users/\(memberKeyArray[indexPath.row])")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    if (rest.key == "imageURL"){
                        urlString = rest.value! as! String
                        let url = NSURL(string: urlString)
                        
                        //myCell.setImage(profile: UIImage(named: "blank")!)
                        
                        // If this image is already cached, don't re-download
                        if let img = self.imageCache[urlString] {
                            myCell.setImage(profile: img)
                        }
                            
                        else {
                            // The image isn't cached, download the img data
                            // We should perform this in a background thread
                            let session = URLSession.shared
                            let request = NSURLRequest(url: url! as URL)
                            let dataTask = session.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) -> Void in
                                if error == nil {
                                    // Convert the downloaded data in to a UIImage object
                                    let image = UIImage(data: data!)
                                    // Store the image in to our cache
                                    self.imageCache[urlString] = image
                                    // Update the cell
                                    DispatchQueue.main.async(execute: {
                                        myCell.setImage(profile: image!)
                                    })
                                }
                                else {
                                    print("Error: \(String(describing: error?.localizedDescription))")
                                }
                            }
                            dataTask.resume()
                        }
                    }
                }
            }
        });

        
        return myCell
    }
    
    @IBAction func addMember(_ sender: Any) {
        self.performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        //let nav = segue.destination as!UINavigationController
        let searchMember = segue.destination as! SearchMembers
            
        searchMember.groupKey = groupKey
        
        searchMember.groupName = groupName
        
        let userId = (UserDefaults.standard.value(forKey: "user_id_taskforce")) as! String
        if (userId == admin){
            searchMember.isAdmin = true
        }
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
}

