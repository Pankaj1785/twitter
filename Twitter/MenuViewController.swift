//
//  MenuViewController.swift
//  MenuSlideOut
//
//  Created by Ian on 5/28/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activeViewContainer: UIView!
  @IBOutlet weak var activeViewXConstraint: NSLayoutConstraint!
  
  @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
    if sender.state == .Ended {
      UIView.animateWithDuration(0.35, animations: {
        self.activeViewXConstraint.constant = -200
        self.view.layoutIfNeeded()
      })
    }
  }
  
  private var activeViewController: UIViewController? {
    didSet {
      removeInactiveViewController(oldValue)
      updateActiveViewController()
    }
  }
  
  private var viewControllerArray: [UIViewController] = []
  
  var viewControllers: [UIViewController]  {
    get { // getter returns read only copy
      let immutableCopy = viewControllerArray
      return immutableCopy
    }
    set {
      viewControllerArray = newValue
      
      // set the active view controller to the first one in the new array if the current one is not in there
      if activeViewController == nil || viewControllerArray.indexOf(activeViewController!) == nil {
        activeViewController = viewControllerArray[1]
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureToolbar()
    self.initViewControllers()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight =  50
    tableView.reloadData()
    
    var sidebarBackgroundView = UIView(frame: CGRectZero)
    self.tableView.tableFooterView = sidebarBackgroundView
    self.tableView.backgroundColor = UIColor.clearColor()
    
    self.activeViewXConstraint.constant = 0
    self.activeViewController = self.viewControllerArray[1]
    updateActiveViewController()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func initViewControllers() {
    // profile
    let vc1 = storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
    vc1.user = User.currentUser!
    let nc1 = UINavigationController(rootViewController: vc1)
    
    // tweets
    let vc2 = storyboard!.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
    let nc2 = UINavigationController(rootViewController: vc2)
    
    // mentions
    let vc3 = storyboard!.instantiateViewControllerWithIdentifier("MentionsViewController") as! MentionsViewController
    let nc3 = UINavigationController(rootViewController: vc3)
    
    viewControllerArray = [nc1, nc2, nc3]
  }
  
  private func removeInactiveViewController(inactiveViewController: UIViewController?) {
    if isViewLoaded() {
      if let inActiveVC = inactiveViewController {
        inActiveVC.willMoveToParentViewController(nil)
        inActiveVC.view.removeFromSuperview()
        inActiveVC.removeFromParentViewController()
      }
    }
  }
  
  private func updateActiveViewController() {
    if isViewLoaded() {
      if let activeVC = activeViewController {
        addChildViewController(activeVC)
        activeVC.view.frame = activeViewContainer.bounds
        activeViewContainer.addSubview(activeVC.view)
        self.navigationItem.title = activeVC.title
        activeVC.didMoveToParentViewController(self)
      }
    }
  }

  func configureToolbar() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .Plain, target: self, action: "logout")
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .Plain, target: self, action: "compose")
  }
  
  func logout() {
    User.currentUser?.logout()
  }
  
  func compose() {
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    var composeViewController = storyboard.instantiateViewControllerWithIdentifier("ComposeViewController") as! ComposeViewController
    
    self.navigationController?.pushViewController(composeViewController, animated: true)
  }
}

// MARK: view controller delegates
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewControllerArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! UITableViewCell
    cell.textLabel?.text = viewControllerArray[indexPath.row].title
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    activeViewController = viewControllerArray[indexPath.row]
    
    UIView.animateWithDuration(0.35, animations: {
      self.activeViewXConstraint.constant = 0
      self.view.layoutIfNeeded()
    })
  }
}