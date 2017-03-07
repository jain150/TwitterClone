//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Arnav Jain on 25/02/17.
//  Copyright © 2017 Arnav Jain. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    static var tweets: [Tweet]?
    let refreshControl = UIRefreshControl()
    var profileTweet:NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            TweetsViewController.tweets = tweets
            self.tableView.reloadData()

            for tweet in tweets {
                print(tweet)
            }
            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            TweetsViewController.tweets = tweets
            self.tableView.reloadData()
            for tweet in tweets {
                //print(tweet.imageURL)
            }
            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func imageViewPressed(_ sender: Any) {
//        let senderView = sender as! UIImageView
//        let tweet = TweetsViewController.tweets![senderView.tag] as! Tweet
//        print("tweet")
//    }
    
    @IBAction func avatarButton(_ sender: Any) {
        let senderCell = sender as! UIButton
        let tweet = TweetsViewController.tweets?[senderCell.tag]
        print((tweet?.screen_name!)!)
        TwitterClient.sharedInstance?.getUser(id: (tweet?.screen_name!)!, success: { (response: NSDictionary) in
            self.profileTweet = response
            self.performSegue(withIdentifier: "profile", sender: sender)
            print(response)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        print("hello")
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            TweetsViewController.tweets = tweets
            self.tableView.reloadData()
            
            for tweet in tweets {
                print(tweet)
            }
            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
        refreshControl.endRefreshing()

    }
    
    @IBAction func onLogoutPressed(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = TweetsViewController.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.tweetLabel.text = TweetsViewController.tweets![indexPath.row].text
        cell.tweet = TweetsViewController.tweets![indexPath.row]
        cell.indexPathRow = indexPath.row
        if let imageURL = TweetsViewController.tweets![indexPath.row].imageURL {
            let newImageURL = imageURL.replacingOccurrences(of: "_normal", with: "")
            cell.avatarImageView.setImageWith(URL(string: newImageURL)!)
            cell.userLabel.text = TweetsViewController.tweets![indexPath.row].user
            
            cell.avatarButton.tag = indexPath.row
            cell.avatarImageView.tag = indexPath.row


            if cell.tweet.favourited == true {
                //self.favImgView.image = UIImage(named: "favor-icon-red")
                cell.favButton.setImage(UIImage(named: "favor-icon-red"), for: .normal)
            } else {
                //self.favImgView.image = UIImage(named: "favor-icon")
                cell.favButton.setImage(UIImage(named: "favor-icon"), for: .normal)
                
            }
            
            if cell.tweet.retweeted == true {
                cell.retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: .normal)
                //self.favImgView.image = UIImage(named: "retweet-icon")
                
            } else {
                cell.retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            }


            print(cell.tweet)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            
            let senderCell = sender as! TweetCell
            
            
            let destination = segue.destination as! DetailsViewController
            let indexPath = tableView.indexPath(for: senderCell)
            print(indexPath)
            destination.tweet = TweetsViewController.tweets?[indexPath!.row as! Int]
            destination.indexPath = indexPath!.row
            destination.ImageName = senderCell.tweet.imageURL
        }
        if segue.identifier == "currentuser" {
            let destination = segue.destination as! ProfileViewController
            destination.backImageURL = User.currentUser?.dictionary!["profile_banner_url"] as! String
            destination.avatarImageURL = (User.currentUser?.dictionary!["profile_image_url_https"] as! String).replacingOccurrences(of: "_normal", with: "")
            
            destination.followersText = User.currentUser!.dictionary!["followers_count"] as! Int
            destination.followingText = User.currentUser!.dictionary!["friends_count"] as! Int
            destination.tweetsText = User.currentUser!.dictionary!["statuses_count"] as! Int


            print(User.currentUser!.dictionary!)
            //print(User.currentUser!.dictionary!["followers_count"] as? String)
        }
        if segue.identifier == "profile" {
            let destination = segue.destination as! ProfileViewController
            if let url = self.profileTweet["profile_banner_url"] as? String {
                destination.backImageURL = self.profileTweet["profile_banner_url"] as! String

            }
            destination.avatarImageURL = (self.profileTweet["profile_image_url_https"] as! String).replacingOccurrences(of: "_normal", with: "")
            
            destination.followersText = self.profileTweet["followers_count"] as! Int
            destination.followingText = self.profileTweet["friends_count"] as! Int
            destination.tweetsText = self.profileTweet["statuses_count"] as! Int
        }
    }

}
