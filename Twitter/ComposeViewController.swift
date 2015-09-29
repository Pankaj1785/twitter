//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Ian on 5/24/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetTextView: UITextView!
  @IBOutlet weak var tweetButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    profileImageView.setImageWithURL(User.currentUser!.profileImageURL!)
    nameLabel.text = User.currentUser!.name
    screenNameLabel.text = "@\(User.currentUser!.screenName!)"
    
    profileImageView.layer.cornerRadius = 5
    profileImageView.clipsToBounds = true

    tweetTextView.layer.cornerRadius = 3
    tweetTextView.clipsToBounds = true
    
    tweetButton.layer.cornerRadius = 3
    tweetButton.clipsToBounds = true
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
    
    tweetTextView.delegate = self
    
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: "didTapView")
    self.view.addGestureRecognizer(tapRecognizer)
    
    tweetButton.addTarget(self, action: "onTweet", forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func onCancel(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func onTweet() {
    TwitterClient.sharedInstance.updateWithParams(["status" : tweetTextView.text], completion: { (status, error) -> () in
      self.tweetTextView.resignFirstResponder()
      
      var menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
      
      self.navigationController?.pushViewController(menuViewController, animated: true)
    })
  }
  
  func didTapView(){
    self.view.endEditing(true)
  }
}

extension ComposeViewController: UITextViewDelegate {
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      self.tweetTextView.resignFirstResponder()
      
      return false
    }
    
    return true
  }
}
