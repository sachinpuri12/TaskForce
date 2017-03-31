//
//  Login.swift
//  TaskForce
//
//  Created by David Lee-Tolley on 3/29/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import Firebase

class Login: UIViewController, FBSDKLoginButtonDelegate{
    
    var db: FIRDatabaseReference!
    
    var username: String = ""
    var imageURL: String = ""
    var FBId: String = ""
    var posterRating: Double = 0.0
    var totalPosts: Int = 0
    var taskerRating: Double = 0.0
    var totalTasks: Int = 0
    var address: String = ""
    var phone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = FIRDatabase.database().reference()
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.delegate = self
        
//        if FBSDKAccessToken.current() != nil{
//            performSegue(withIdentifier: "loginSuccess", sender: nil)
//        }
        
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error == nil {
            print("Login successful")
            getFacebookUserInfo()
            
            print("2." + self.username)
            //insert user into database
            
            
            performSegue(withIdentifier: "loginSuccess", sender: nil)
            return
        }
        
        print("An error has occured...\(error)")
        
    }
    
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, first_name, last_name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                
                self.username = (data["first_name"]! as! String) + "-" + (data["last_name"]! as! String)
                self.FBId = data["id"]! as! String
                self.imageURL = "https://graph.facebook.com/\(self.FBId)/picture?type=large&return_ssl_resources=1"
                print("1." + self.username)
                
                let userExists = self.checkUser()
                
//                if !(userExists){
//                    self.createUser()
//                }
                self.createUser()
            })
            connection.start()
        }
    }
    
    func checkUser() -> Bool {
        var check = false
        self.db.child("Users").childByAutoId().queryOrdered(byChild: "FBId").queryEqual(toValue: self.FBId).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()) {
                print("snapshot exists")
                check = true
            }else{
                print("snapshot doesnt exist")
            }
        })
        return check
    }


    func createUser(){
        let newUser = [
            "username": self.username,
            "imageURL": self.imageURL,
            "FBId": self.FBId,
            "posterRating": self.posterRating,
            "totalPosts": self.totalPosts,
            "taskerRating": self.taskerRating,
            "totalTasks": self.totalTasks,
            "address": self.address,
            "phone": self.phone
            ] as [String: Any]
        // FIXME make price and tip decimal format
        
        self.db.child("users").childByAutoId().setValue(newUser);
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout successful")
    }
    
    
    
    
    
}
