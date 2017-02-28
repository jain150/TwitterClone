//
//  TwitterClient.swift
//  Twitter
//
//  Created by Arnav Jain on 25/02/17.
//  Copyright © 2017 Arnav Jain. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "jmuVvT3aSLiZxICj5wp9WUGD7", consumerSecret: "kfOcW8zdI0MKbuc5d2RjiCekAbebXpl5WZewEvNeSSNpzU0hb0")
    
    var loginSucess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {

        TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let responseDictionaries = response as! [NSDictionary]
            let tweets = Tweet.TweetsFromArray(dictionaries: responseDictionaries)
            success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func verifyCredentials(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response : Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            print(user.name!)
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                failure(error)
        })
    }
    
    
    
    func getTweet(id: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        TwitterClient.sharedInstance?.get("1.1/statuses/show/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response : Any?) in
            let dictionary = response as! NSDictionary
            success(dictionary)
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            failure(error)
        })
    }
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSucess = success
        loginFailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "myTwitterApp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            let token = requestToken?.token
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!)")
            
            UIApplication.shared.open(url!, options: [:], completionHandler: { (result : Bool) in
                print(result)
            })
            
            }, failure: { (error: Error?) in
                print(error?.localizedDescription)
                self.loginFailure?(error!)
        })

    }
    
    func retweet(id: String, success: @escaping (Tweet) -> (), faliure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let tweet = Tweet.init(dictionary: response)
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            faliure(error)
        }
    }
    
//    func favorite(id: String, success: @escaping (Tweet) -> (), faliure: @escaping (Error) -> ()) {
//        post("1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//            let response = response as! NSDictionary
//            let tweet = Tweet.init(dictionary: response)
//            success(tweet)
//            
//        }) { (task: URLSessionDataTask?, error: Error) in
//            faliure(error)
//        }
//    }
//    
    func favorite(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        self.post("https://api.twitter.com/1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task, response) in
            success()
        }) { (task, error) in
            failure(error)
        }
    }

    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogout), object: nil)
    }
    
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.verifyCredentials(success: { (user: User) in
                User.currentUser = user
                self.loginSucess?()
                }, failure: { (error: Error) in
                    self.loginFailure?(error)
            })
            
            }, failure: { (error: Error?) in
                print(error?.localizedDescription)
                self.loginFailure?(error!)
        })
    }
    
}
