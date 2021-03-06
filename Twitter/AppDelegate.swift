//
//  AppDelegate.swift
//  Twitter
//
//  Created by Ian on 5/20/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var storyboard = UIStoryboard(name: "Main", bundle: nil)
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    UINavigationBar.appearance().barTintColor = UIColor(red: 88.0/255.0, green: 184.0/255.0, blue: 241.0/255.0, alpha: 1.0)
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    
    let font = UIFont(name: "HelveticaNeue", size:15.0)!
    UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
    
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
    
    if User.currentUser != nil {
      print("Current user: \(User.currentUser!.name!)")
      
      var vc = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
      let navigationController = UINavigationController(rootViewController: vc)
      window?.rootViewController = navigationController
    }
    
    return true
  }
  
  func userDidLogout() {
    var vc = storyboard.instantiateInitialViewController() as! UIViewController!
    window?.rootViewController =  vc
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    TwitterClient.sharedInstance.openURL(url)
    
    return true
  }
}

