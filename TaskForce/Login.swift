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

class Login: UIViewController, FBSDKLoginButtonDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.delegate = self
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error == nil {
            print("Login successful")
            performSegue(withIdentifier: "loginSuccess", sender: nil)
            return
        }
        print("An error has occured...\(error)")
        
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout successful")
    }
    
    
    
    
    
}
