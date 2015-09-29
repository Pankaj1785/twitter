//
//  TweetViewController.swift
//  Twitter
//
//  Created by Ian on 5/22/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var replyView: UIView!
  @IBOutlet weak var tweetTextView: UITextView!
  @IBOutlet weak var tweetButton: UIButton!
  
  var tweet: Tweet!
  var isReply: Bool = false
  
  override func viewWillAppear(animated: Bool) {
    replyView.hidden = !isReply
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if isReply == true {
      self.title = "Reply to @\(tweet.user!.screenName!)"
      replyButton.enabled = false
    }
    
    if User.currentUser!.id! == tweet.user!.id! {
      retweetButton.enabled = false
    } else if let retweeted = tweet.retweeted {
      if retweeted == true {
        retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
        retweetButton.enabled = false
      }
    }
    
    if let favorited = tweet.favorited {
      if favorited == true {
        favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
      }
    }

    profileImageView.setImageWithURL(tweet!.user!.profileImageURL)
    nameLabel.text = tweet!.user!.name
    screenNameLabel.text = "@\(tweet!.user!.screenName!)"
    tweetTextLabel.text = tweet.text
    tweetTextView.text = "@\(tweet!.user!.screenName!) "
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm a - dd MMM YYYY"
    createdAtLabel.text = formatter.stringFromDate(tweet.createdAt!)
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    
    tweetTextView.layer.cornerRadius = 3
    tweetTextView.clipsToBounds = true
    
    tweetButton.layer.cornerRadius = 3
    tweetButton.clipsToBounds = true
    
    tweetTextView.delegate = self
    
    let tapRecognizer = UITapGestureRecognizer()
    tapRecognizer.addTarget(self, action: "didTapView")
    self.view.addGestureRecognizer(tapRecognizer)
    
    replyButton.addTarget(self, action: "onReply", forControlEvents: UIControlEvents.TouchUpInside)
    retweetButton.addTarget(self, action: "onRetweet", forControlEvents: UIControlEvents.TouchUpInside)
    favoriteButton.addTarget(self, action: "onFavorite", forControlEvents: UIControlEvents.TouchUpInside)
    tweetButton.addTarget(self, action: "onTweet", forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  @IBAction func didTapBackButton(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func onCompose(sender: AnyObject) {
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    var composeViewController = storyboard.instantiateViewControllerWithIdentifier("ComposeViewController") as! ComposeViewController
    
    self.navigationController?.pushViewController(composeViewController, animated: true)
  }
  
  func onReply() {
    replyView.hidden = false
    replyButton.enabled = false
    self.title = "Reply to @\(tweet.user!.screenName!)"
  }
  
  func onRetweet() {
    TwitterClient.sharedInstance.retweetWithParams(tweet.id!, params: nil, completion: { (status, error) -> () in
      if error == nil {
        self.retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
      }
    })
  }
  
  func onFavorite() {
    TwitterClient.sharedInstance.favoritesWithParams(["id" : tweet.id!], completion: { (status, error) -> () in
      if error == nil {
        self.favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
      }
    })
  }
  
  func onTweet() {
    TwitterClient.sharedInstance.updateWithParams(["status" : tweetTextView.text, "in_reply_to_status_id" : tweet.id!], completion: { (status, error) -> () in
      self.tweetTextView.resignFirstResponder()
      
      self.dismissViewControllerAnimated(true, completion: nil)
    })
  }
  
  func didTapView(){
    self.view.endEditing(true)
  }
}

extension TweetViewController: UITextViewDelegate {
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      self.tweetTextView.resignFirstResponder()
      
      return false
    }
    
    return true
  }
}
