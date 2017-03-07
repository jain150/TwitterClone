//
//  Tweet.swift
//  Twitter
//
//  Created by Arnav Jain on 25/02/17.
//  Copyright © 2017 Arnav Jain. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var timestamp: NSDate?
    var user: String?
    var retweetCount: Int = 0
    var favouriteCount: Int = 0
    var text: String?
    var imageURL: String?
    var id:String?
    var retweeted:Bool!
    var favourited:Bool!
    var screen_name:String!
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        let userDictionary = dictionary["user"] as! NSDictionary
        imageURL = userDictionary["profile_image_url_https"] as? String
        user = userDictionary["name"] as? String
        id = dictionary["id_str"] as? String
        retweeted = dictionary["retweeted"] as! Bool
        favourited = dictionary["favorited"] as! Bool
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouriteCount = (dictionary["favorite_count"] as? Int) ?? 1
        screen_name = userDictionary["screen_name"] as! String

  //      favouriteCount = (userDictionary["favorite_count"] as? Int) ?? 0
//        favouriteCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        
        var favCount = 0
        TwitterClient.sharedInstance?.getTweet(id: id!, success: { (dict: NSDictionary) in
            favCount = dict["favorite_count"] as! Int
            print("This is \(favCount)")
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        let timeStampString = dictionary["created_at"] as? String
        
        if let timeStampString = timeStampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timeStampString) as NSDate?
        }
        
        
    }
    
    class func TweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            
        }
        
        return tweets
        
    }
    

}
