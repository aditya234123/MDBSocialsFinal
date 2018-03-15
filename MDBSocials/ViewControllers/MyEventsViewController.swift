//
//  MyEventsViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 3/3/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
import PromiseKit
import CoreLocation
import MapKit

class MyEventsViewController: UIViewController {
    
    var interestedPostIDs = [String]()
    var interestedPosts = [Post]()
    
    var selectedCell: Int?

    var collectionView: UICollectionView!
    var currentUser: UserModel?
    
    override func viewDidLoad() {
         NotificationCenter.default.addObserver(self, selector: #selector(openModal), name: .modal, object: nil)
        setUpNavBar()
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        getCurrentUserAndPosts()
    }
    
    @objc func openModal(_ notification: Notification) {
        if self.tabBarController?.selectedIndex == 1 {
            print("yea")
        let dict = notification.userInfo as! [String : String]
        let id = dict["id"]
        let list = InterestedListView(frame: CGRect(x: 50, y: 50, width: view.frame.width - 100, height: view.frame.height - 100), id: id!)
        let modalView = AKModalView(view: list)
        modalView.dismissAnimation = .FadeOut
        self.navigationController?.view.addSubview(modalView)
        modalView.show()
        }
    }
    
    func getCurrentUserAndPosts() {
        
        log.verbose("Getting user and posts for my events.")
        UserAuthHelper.getCurrentUser().then { (user) in
        FirebaseAPIClient.fetchUser(id: user.uid).then {
                u -> Void in
                self.currentUser = u
            }
            }.then { _ -> Void in
                self.getMyInterestedPosts()
        }
    }
    
    func getMyInterestedPosts() {
        self.interestedPosts = [Post]()
        self.interestedPostIDs = [String]()
        FirebaseAPIClient.getUserInterests(userID: (currentUser?.id!)!).then { (ids) -> Void in
            
            let group = DispatchGroup()
            //go thru all ids and get post info for em
            for id in ids {
                group.enter()
                FirebaseAPIClient.getPostInfo(postID: id, withBlock: { (post) in
                    self.interestedPosts.append(post)
                    self.interestedPostIDs.append(post.id!)
                    group.leave()
                })
            }
            
            group.notify(queue: .main, execute: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.short
                self.interestedPosts.sort(by: { (x, y) -> Bool in
                    let xDate = dateFormatter.date(from: x.date!)
                    let yDate = dateFormatter.date(from: y.date!)
                    return xDate! < yDate!
                })
                self.collectionView.reloadData()
            })
            
            }.then {
                FirebaseAPIClient.fetchNewInterests(userID: (self.currentUser?.id)!, withBlock: { (id) in
                    if !self.interestedPostIDs.contains(id) {
                        FirebaseAPIClient.getPostInfo(postID: id, withBlock: { (post) in
                            self.interestedPosts.append(post)
                            self.interestedPostIDs.append(post.id!)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = DateFormatter.Style.medium
                            dateFormatter.timeStyle = DateFormatter.Style.short
                            self.interestedPosts.sort(by: { (x, y) -> Bool in
                                let xDate = dateFormatter.date(from: x.date!)
                                let yDate = dateFormatter.date(from: y.date!)
                                return xDate! < yDate!
                            })
                            self.collectionView.reloadData()
                        })
                    }
                })
        }
    }
    
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 10)
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
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedViewCell
        for x in cell.contentView.subviews {
            x.removeFromSuperview()
        }
        cell.awakeFromNib()
        
        let post = interestedPosts[indexPath.item]
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = post.location
        let search = MKLocalSearch(request: request)
        var lat: Double = 0
        var lon: Double = 0
        var epochTime:TimeInterval = 0
        search.start { response, error in
            guard let response = response else {
                log.warning("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
                return
            }
            let first = response.mapItems[0]
            lat = first.placemark.coordinate.latitude
            lon = first.placemark.coordinate.longitude
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.short
            let date = dateFormatter.date(from: post.date!)
            epochTime = (date?.timeIntervalSince1970)!
        }
        
        cell.id = post.id
        StorageHelper.getProfilePic(id: post.id!).then { (image) -> Void in
            post.image = image
            }.then { _ -> Promise<[String]> in
                return FirebaseAPIClient.fetchInterested(postID: post.id!, names: false)
            }.then { arr -> Promise<Int> in
                if arr.contains((self.currentUser?.id)!) {
                    post.userInterested = true
                }
                return FirebaseAPIClient.fetchRSVP(postID: post.id!)
            }.then { rsvpNum -> Void in
                post.RSVP = rsvpNum
            }.then { _ -> Promise<String> in
                DarkSkyAPIHelper.findForecast(lat: lat, lon: lon, time: epochTime)
            }.then { (type) -> Void in
                
                var img = UIImage()
                if type == "snow" || type == "sleet" || type == "hail" {
                    //snow icon
                    img = UIImage(named: "snow")!
                }
                else if type == "clear-day" || type == "clear-night" || type == "wind" || type == "fog" {
                    //sun
                    img = UIImage(named: "sun")!
                }
                else if type == "cloudy" || type == "partly-cloudy-day" || type == "partly-cloudy-night" {
                    //cloud
                    img = UIImage(named: "cloudy")!
                }
                else if type == "rain" || type == "thunderstorm" || type == "tornado" {
                    //rain
                    img = UIImage(named: "rain")!
                }
                cell.bgClearIcon.image = img
            }.always {
                DispatchQueue.main.async {
                    cell.nameLabel.text = post.personName
                    cell.eventLabel.text = post.eventName
                    cell.RSVP.setTitle("\(post.RSVP!)", for: .normal)
                    cell.date.text = post.date
                    if post.userInterested! {
                        let image = UIImage(named: "star2")
                        cell.starImageView.image = image
                    } else {
                        let image = UIImage(named: "star")
                        cell.starImageView.image = image
                    }
                    cell.image.image = post.image
                    cell.setNeedsLayout()
                    cell.image.hero.id = "image" + "\(indexPath.item)"
                    cell.nameLabel.hero.id = "name" + "\(indexPath.item)"
                    cell.eventLabel.hero.id = "event" + "\(indexPath.item)"
                    cell.date.hero.id = "date" + "\(indexPath.item)"
                    cell.RSVP.hero.id = "RSVP" + "\(indexPath.item)"
                    cell.starImageView.hero.id = "star" + "\(indexPath.item)"
                }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width - 20, height: 150)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath.item
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tabBarController?.tabBar.isHidden = true
        let destVC = segue.destination as! DetailViewController
        let imgHero = "image" + "\(selectedCell!)"
        let eventHero = "event" + "\(selectedCell!)"
        let nameHero = "name" + "\(selectedCell!)"
        let RSVPHero = "RSVP" + "\(selectedCell!)"
        let dateHero = "date" + "\(selectedCell!)"
        let starHero = "star" + "\(selectedCell!)"
        destVC.post = interestedPosts[selectedCell!]
        destVC.currentUser = self.currentUser
        destVC.setUpView()
        destVC.image.hero.id = imgHero
        destVC.eventLabel.hero.id = eventHero
        destVC.nameLabel.hero.id = nameHero
        destVC.dateLabel.hero.id = dateHero
        destVC.RSVP.hero.id = RSVPHero
        destVC.starImage.hero.id = starHero
    }

}

