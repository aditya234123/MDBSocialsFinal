//
//  MyEventsViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 3/3/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class MyEventsViewController: UIViewController {
    
    var interestedPosts = [Post]()

    var collectionView: UICollectionView!
    var userID: String?
    
    override func viewDidLoad() {
        getCurrentUser()
        getMyInterestedPosts()
        setUpNavBar()
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    func getCurrentUser() {
        UserAuthHelper.getCurrentUser { (user) in
            self.userID = user.uid
        }
    }
    
    func getMyInterestedPosts() {
        FirebaseAPIClient.getUserInterests(userID: userID!) { (postID) in
            FirebaseAPIClient.getPostInfo(postID: postID, withBlock: { (post) in
                self.interestedPosts.append(post)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            })
        }
        //promises good here
        /*
        FirebaseAPIClient.fetchPosts { (post) in
            if (self.postIDs.contains(post.id!)) {
                self.interestedPosts.append(post)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
         */
        
    }
    
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (self.navigationController?.navigationBar.frame.height)!), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeedViewCell.self, forCellWithReuseIdentifier: "feedCell")
        view.addSubview(collectionView)
    }
    
    func setUpNavBar() {
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 19)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        
        self.navigationItem.title = "My Events"
        
    }
    


}


extension MyEventsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestedPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Implement Dark Sky Here as well. Could pass data into.
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedViewCell
        for var x: UIView in cell.contentView.subviews {
            x.removeFromSuperview()
        }
        cell.awakeFromNib()
        let post = interestedPosts[indexPath.item]
        //cell.id = post.id
        StorageHelper.getProfilePic(id: post.id!, withBlock: { (image) in
            post.image = image
            DispatchQueue.main.async{
                cell.image.image = self.interestedPosts[indexPath.item].image!
                cell.setNeedsLayout()
            }
        })
        
        FirebaseAPIClient.fetchInterested(postID: post.id!) { (arr) in
            if arr[0] == self.userID {
                post.userInterested = true
                let image = UIImage(named: "star2")
                DispatchQueue.main.async {
                    cell.starImageView.image = image
                    cell.setNeedsLayout()
                }
            }
            
        }
        FirebaseAPIClient.fetchRSVP(postID: post.id!) { (rsvpNum) in
            cell.RSVP.setTitle("\(rsvpNum)", for: .normal)
            post.RSVP = rsvpNum
        }
        cell.nameLabel.text = post.personName
        cell.eventLabel.text = post.eventName
        cell.RSVP.setTitle("\(post.RSVP!)", for: .normal)
        cell.date.text = post.date
        
        if post.userInterested! {
            let image = UIImage(named: "star2")
            DispatchQueue.main.async {
                cell.starImageView.image = image
            }
        }
        
        cell.image.hero.id = "image" + "\(indexPath.item)"
        cell.nameLabel.hero.id = "name" + "\(indexPath.item)"
        cell.eventLabel.hero.id = "event" + "\(indexPath.item)"
        cell.date.hero.id = "date" + "\(indexPath.item)"
        cell.RSVP.hero.id = "RSVP" + "\(indexPath.item)"
        cell.starImageView.hero.id = "star" + "\(indexPath.item)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width - 20, height: 150)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //IMPLEMENT
        //self.performSegue(withIdentifier: "toDetail", sender: self)
    }

}

