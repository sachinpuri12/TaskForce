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

var globalUser: String = ""
var globalId: String = ""
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
        
//        if (FBSDKAccessToken.current() != nil) {
//            print("ALREADY LOGGED IN")
//            getFacebookUserInfo()
//        } else {
            print("NOT LOGGED IN")
            db = FIRDatabase.database().reference()
            let loginButton = FBSDKLoginButton()
            loginButton.frame = CGRect(x: 16, y: 300, width: view.frame.width - 32, height: 50)
            loginButton.setTitle("Join the Force", for: .highlighted)
            loginButton.layer.cornerRadius = 10
            loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            view.addSubview(loginButton)
            loginButton.delegate = self
        
//            let customLoginButton = UIButton(type: .system)
//            customLoginButton.backgroundColor  = UIColor.darkGray
//            customLoginButton.frame = CGRect(x: 16, y: 300, width: view.frame.width - 32, height: 50)
//            customLoginButton.setTitle("Join the Force", for: .normal)
//            customLoginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//            customLoginButton.setTitleColor(.white, for: .normal)
//            customLoginButton.layer.cornerRadius = 5
//            view.addSubview(customLoginButton)
//        
//        customLoginButton.addTarget(self, action:(#selector(loginButton)), for: .touchUpInside)
//        }
    
    }
//    
//    func handleCustomLoginButton() {
//        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile"], from: self)
//        {
//            (result, err) in
//            if err != nil {
//                print("An error has occured... ", err)
//                return
//            }
//        }
//        print("Login successful")
//            
//        getFacebookUserInfo()
//            
//        self.performSegue(withIdentifier: "loginSuccess", sender: nil)
//        return
//    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error == nil {
            print("Login successful")
            
            getFacebookUserInfo()
            
            performSegue(withIdentifier: "loginSuccess", sender: nil)
            return
        }
        
        print("An error has occured...\(error)")
        
    }
    
    func getFacebookUserInfo() {
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            //print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, first_name, last_name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                
                self.username = (data["first_name"]! as! String) + "-" + (data["last_name"]! as! String)
                self.FBId = data["id"]! as! String
                
                self.imageURL = "https://graph.facebook.com/\(self.FBId)/picture?type=large&return_ssl_resources=1"
                
                
                self.checkUser()
                globalUser = self.username
                globalId = self.FBId
                
                setUserKeyIfNil()

            })
            connection.start()
        }
    }
    
    func checkUser() {
        let usersRef = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users")
        
        usersRef.queryOrdered(byChild: "FBId").queryEqual(toValue: "\(self.FBId)")
            .observeSingleEvent(of: .value, with: { snapshot in
                if ( snapshot.value is NSNull ) {
                    self.createUser() //didnt find it, ok to proceed
                    
                }
            })
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
            "phone": self.phone,
            "groups": []
            ] as [String: Any]
        // FIXME make price and tip decimal format
        
        let ref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users")
        
        let newUserRef = ref.childByAutoId()
        newUserRef.setValue(newUser)
       
        let newUserID = newUserRef.key
     
       
        
        UserDefaults.standard.setValue(newUserID, forKey: "user_id_taskforce")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout successful")
    }
    
    
    
    
    
}
