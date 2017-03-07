//
//  DetailsViewController.swift
//  Twitter
//
//  Created by Arnav Jain on 04/03/17.
//  Copyright © 2017 Arnav Jain. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var ImageName:String?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!

    @IBOutlet weak var retweetLabel: UILabel!
    
    var tweet:Tweet!
    var indexPath:Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retweetButton.addTarget(self, action: #selector(TweetCell.onRetweetPressed), for: .touchUpInside)
        favButton.addTarget(self, action: #selector(TweetCell.onFavouritePressed), for: .touchUpInside)
        print("This is bra \(indexPath)")
        if TweetsViewController.tweets![indexPath].favourited == true {
            //self.favImgView.image = UIImage(named: "favor-icon-red")
            self.favButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            //self.favImgView.image = UIImage(named: "favor-icon")
            self.favButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            
        }
        
        if TweetsViewController.tweets![indexPath].retweeted == true {
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)

            //self.favImgView.image = UIImage(named: "retweet-icon")
            
        } else {
            self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }


        colorView.layer.allowsGroupOpacity = false
        if let url = ImageName {
            let newImageURL = url.replacingOccurrences(of: "_normal", with: "")
            self.avatarImageView.layer.cornerRadius = 13
            self.avatarImageView.clipsToBounds = true
            self.avatarImageView.setImageWith(URL(string:newImageURL)!)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //print(TweetsViewController.tweets)
        print(TweetsViewController.tweets![indexPath].favouriteCount)
        
        if TweetsViewController.tweets![indexPath].favourited == true {
            //self.favImgView.image = UIImage(named: "favor-icon-red")
            self.favButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
        } else {
            //self.favImgView.image = UIImage(named: "favor-icon")
            self.favButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            
        }
        
        if TweetsViewController.tweets![indexPath].retweeted == true {
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
            //self.favImgView.image = UIImage(named: "retweet-icon")
            
        } else {
            self.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        }
        self.favLabel.text = "\(TweetsViewController.tweets![indexPath].favouriteCount) LIKES"
        self.retweetLabel.text = "\(TweetsViewController.tweets![indexPath].retweetCount) RETWEETS"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRetweetPressed() {
        
        let tweetID = tweet?.id
        TwitterClient.sharedInstance?.getTweet(id: tweetID!, success: { (dict: NSDictionary) in
            let count = dict["retweet_count"] as! Int
            let retweeted = dict["retweeted"] as! Bool
            if retweeted == false {
                TwitterClient.sharedInstance?.retweet(id: tweetID!, success: { (tweet: Tweet) in
                    self.retweetLabel.text = "\(tweet.retweetCount) RETWEETS"
                    self.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
                    TweetsViewController.tweets![self.indexPath].retweeted = true
                }, faliure: { (error: Error) in
                    print(error.localizedDescription)
                })
            } else {
                
            }
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        
        print(tweet)
    }
    
    func onFavouritePressed() {
        let tweetID = tweet?.id
        
        TwitterClient.sharedInstance?.getTweet(id: tweetID!, success: { (dictionary: NSDictionary) in
            let count = dictionary["favorite_count"] as! Int
            let favourited = dictionary["favorited"] as! Bool
            if favourited == false {
                TwitterClient.sharedInstance?.favorite(id: tweetID!, success: { (tweet: Tweet) in
                    //self.favLabel.text = "\(tweet.favouriteCount)"
                    self.favButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
                    TweetsViewController.tweets![self.indexPath].favourited = true
                    
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
                })
                
                
            }
            self.favLabel.text = "\(count + 1) LIKES"
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! ReplyViewController
        vc.userName = self.tweet!.user!
        
    }
 

}
