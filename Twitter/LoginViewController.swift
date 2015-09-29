//
//  LoginViewController.swift
//  Twitter
//
//  Created by Ian on 5/20/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginButton.layer.cornerRadius = 5
    loginButton.clipsToBounds = true
    loginButton.addTarget(self, action: "onLogin", forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func onLogin() {
    TwitterClient.sharedInstance.loginWithCompletion() { (user: User?, error: NSError?) in
      if user != nil {
        self.performSegueWithIdentifier("loginSegue", sender: self)
      } else {
        //handle error
        print("Login error: \(error)")
      }
    }
  }
}
