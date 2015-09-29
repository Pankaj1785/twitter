//
//  Tweet.swift
//  Twitter
//
//  Created by Ian on 5/20/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var id: Int?
  var user: User?
  var text: String?
  var createdAtString: String?
  var createdAt: NSDate?
  var retweeted: Bool?
  var favorited: Bool?
  
  init(dictionary: NSDictionary) {
    id = dictionary["id"] as? Int
    user = User(dictionary: dictionary["user"] as! NSDictionary)
    text = dictionary["text"] as? String
    createdAtString = dictionary["created_at"] as? String
    retweeted = dictionary["retweeted"] as? Bool
    favorited = dictionary["favorited"] as? Bool

    var formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    createdAt = formatter.dateFromString(createdAtString!)
  }
  
  class func tweetWithArray(array: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    
    for dictionary in array {
      tweets.append(Tweet(dictionary: dictionary))
    }
    
    return tweets
  }
}