//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Arnav Jain on 04/03/17.
//  Copyright © 2017 Arnav Jain. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var followersLabel: UILabel!

    @IBOutlet weak var followingLabel: UILabel!

    @IBOutlet weak var tweetsLabel: UILabel!

    var backImageURL:String?
    var avatarImageURL:String?
    var followersText:Int!
    var followingText:Int!
    var tweetsText:Int!
    
    @IBOutlet weak var mainImage: UIImageView!

    override func viewDidLoad() {
        
        print(followersText)
        
        super.viewDidLoad()
        if let backImageURL = backImageURL {
            backImage.setImageWith(URL(string: backImageURL)!)
        }
        mainImage.layer.cornerRadius = 15
        mainImage.clipsToBounds = true
        if let avatarImageURL = avatarImageURL {
            mainImage.setImageWith(URL(string :avatarImageURL)!)
        }
        // Do any additional setup after loading the view.
        tweetsLabel.text = "\(tweetsText!) Tweets"
        followingLabel.text = "Following: \(followingText!)"
        followersLabel.text = "Followers: \(followersText!)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
