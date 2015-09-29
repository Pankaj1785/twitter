//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ian on 5/20/15.
//  Copyright (c) 2015 Ian Bari. All rights reserved.
//

import UIKit

let twitterConsumerKey = "2Txjamzdam9JEJoojwZeitf1K"
let twitterConsumerSecret = "ALVtI1Z02OpGlUw655BBROrXrQZlgveBZt1mEBaHTQ94JGpMG1"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
  var loginCompletion: ((user: User?, error: NSError?) -> ())?
  
  class var sharedInstance: TwitterClient {
    struct Static {
      static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    
    return Static.instance
  }
  
  func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
    GET("1.1/statuses/home_timeline.json", parameters: params
      , success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let tweets = Tweet.tweetWithArray(response as! [NSDictionary])
        completion(tweets: tweets, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        print("Failed to get home timeline")
        completion(tweets: nil, error: error)
    })
  }
  
  func mentionsTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
    GET("1.1/statuses/mentions_timeline.json", parameters: params
      , success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let tweets = Tweet.tweetWithArray(response as! [NSDictionary])
        completion(tweets: tweets, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        print("Failed to get mentions timeline")
        completion(tweets: nil, error: error)
    })
  }
  
  func updateWithParams(params: NSDictionary?, completion: (status: Tweet?, error: NSError?) -> ()) {
    POST("1.1/statuses/update.json", parameters: params
      , success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let status = Tweet(dictionary: response as! NSDictionary)
        completion(status: status, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        print("Failed to post status: \(error)")
        completion(status: nil, error: error)
    })
  }
  
  func retweetWithParams(id: Int?, params: NSDictionary?, completion: (status: Tweet?, error: NSError?) -> ()) {
    POST("1.1/statuses/retweet/\(id!).json", parameters: params
      , success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let status = Tweet(dictionary: response as! NSDictionary)
        completion(status: status, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        print("Failed to retweet: \(error)")
        completion(status: nil, error: error)
    })
  }
  
  func favoritesWithParams(params: NSDictionary?, completion: (status: Tweet?, error: NSError?) -> ()) {
    POST("1.1/favorites/create.json", parameters: params
      , success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let status = Tweet(dictionary: response as! NSDictionary)
        completion(status: status, error: nil)
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        print("Failed to favorite: \(error)")
        completion(status: nil, error: error)
    })
  }
  
  func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
    loginCompletion = completion
    
    // fetch request token and redirect to authorization view
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
      print("Got the request token")
      let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
      
      UIApplication.sharedApplication().openURL(authURL!)
      }) { (error: NSError!) -> Void in
        print("Failed to get request token")
        self.loginCompletion?(user: nil, error: error)
    }
  }
  
  func openURL(url: NSURL) {
    fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
        print("Got the access token")
        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
      
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil
          , success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            User.currentUser = user
            self.loginCompletion?(user: user, error: nil)
          }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            print("Failed to get current user")
            self.loginCompletion?(user: nil, error: error)
        })
      }) { (error: NSError!) -> Void in
        print("Failed to receive access token")
        self.loginCompletion?(user: nil, error: error)
    }
  }
}
