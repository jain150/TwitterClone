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
                //print(tweet)
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
        cell.tweetLabel.text = TweetsViewController.tweets![indexPath.row].text
        cell.tweet = TweetsViewController.tweets![indexPath.row]
        
        if let imageURL = TweetsViewController.tweets![indexPath.row].imageURL {
            let newImageURL = imageURL.replacingOccurrences(of: "_normal", with: "")
            cell.avatarImageView.setImageWith(URL(string: newImageURL)!)
            cell.userLabel.text = TweetsViewController.tweets![indexPath.row].user
            //print(tweets![indexPath.row].timestamp)
            
            print(TwitterClient.sharedInstance?.getTweet(id: cell.tweet.id!, success: { (dictionary: NSDictionary) in
                let count = dictionary["favorite_count"] as! Int
                cell.favLabel.text = "\(count)"
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            }))
            print(cell.tweet.timestamp)
        }
        
        return cell
    }

}
