//
//  TweetCell.swift
//  Twitter
//
//  Created by Ian on 5/21/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
  optional func tweetCell(tweetCell: TweetCell)
  optional func tweetCell(tweetCell: TweetCell, buttonTouched button: UIButton, didRetweetStatus statusId: Int)
  optional func tweetCell(tweetCell: TweetCell, buttonTouched button: UIButton, didFavoriteStatus statusId: Int)
  optional func tweetCell(tweetCell: TweetCell, didTapProfileImage user: User)
}

class TweetCell: UITableViewCell {
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var retweetLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var createdAtLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var profileImageVerticalSpaceConstraint: NSLayoutConstraint!
  
  weak var delegate: TweetCellDelegate?
  let tapRec = UITapGestureRecognizer()
  
  var tweet: Tweet! {
    didSet {
      profileImageView.setImageWithURL(tweet.user!.profileImageURL)
      nameLabel.text = tweet.user!.name
      screenNameLabel.text = "@\(tweet.user!.screenName!)"
      tweetTextLabel.text = tweet.text
      
      let formatter = NSDateFormatter()
      formatter.dateFormat = "MMM d"
      createdAtLabel.text = formatter.stringFromDate(tweet.createdAt!)
      
      if let retweeted = tweet.retweeted {
        if retweeted == true {
          retweetImageView.image = UIImage(named: "retweet_on")
          retweetLabel.text = "\(User.currentUser!.name!) retweeted"
          retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
          retweetButton.enabled = false
        } else {
          retweetImageView.hidden = true
          retweetLabel.hidden = true
          profileImageVerticalSpaceConstraint?.constant = 8
        }
      }
      
      if User.currentUser!.id! == tweet.user!.id! {
        retweetButton.enabled = false
      }
      
      if let favorited = tweet.favorited {
        if favorited == true {
          favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
        }
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

    profileImageView.layer.cornerRadius = 3
    profileImageView.clipsToBounds = true
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width

    tapRec.addTarget(self, action: "onProfile")
    profileImageView.addGestureRecognizer(tapRec)
    
    replyButton.addTarget(self, action: "onReply", forControlEvents: UIControlEvents.TouchUpInside)
    retweetButton.addTarget(self, action: "onRetweet", forControlEvents: UIControlEvents.TouchUpInside)
    favoriteButton.addTarget(self, action: "onFavorite", forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func onReply() {
    delegate?.tweetCell?(self)
  }
  
  func onRetweet() {
    delegate?.tweetCell?(self, buttonTouched: retweetButton, didRetweetStatus: tweet.id!)
  }
  
  func onFavorite() {
    delegate?.tweetCell?(self, buttonTouched: favoriteButton, didFavoriteStatus: tweet.id!)
  }
  
  func onProfile() {
    delegate?.tweetCell?(self, didTapProfileImage: tweet.user!)
  }
}
