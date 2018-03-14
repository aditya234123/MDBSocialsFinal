//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/19/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
import Hero
import MapKit
import CoreLocation
import PromiseKit

class FeedViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var selectedCell: Int?
    
    var posts = [Post]()
    var postIDs = [String]()
    var currentUser: UserModel?
    
    override func viewDidLoad() {
        setUpTabBar()
        setUpNavBar()
        getCurrentUser()
        self.hero.isEnabled  = true
        getPosts()
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.setUpCollectionView()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setUpTabBar() {
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        self.tabBarController?.tabBar.barTintColor = barColor
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.tintColor = .white
    }
    
    func getCurrentUser() {
        UserAuthHelper.getCurrentUser().then { (user) in
        FirebaseAPIClient.fetchUser(id: user.uid).then {
            u -> Void in
                self.currentUser = u
            }
        }
    }
    
    
    func getPosts() {
        
        FirebaseAPIClient.fetchAllPosts().then { posts -> Void in
            let currentDate = Date.init()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.short
            //let currentDateStr = dateFormatter.string(from: currentDate)
            for post in posts {
                let pDate = dateFormatter.date(from: post.date!)
                if pDate! >= currentDate {
                    self.posts.append(post)
                    self.postIDs.append(post.id!)
                    self.posts.sort(by: { (x, y) -> Bool in
                        let xDate = dateFormatter.date(from: x.date!)
                        let yDate = dateFormatter.date(from: y.date!)
                        return xDate! < yDate!
                    })
                } else {
                    self.postIDs.append(post.id!)
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            }.then { _ -> Void in
                FirebaseAPIClient.fetchNewPosts(withBlock: { (p) in
                    if (!self.postIDs.contains(p.id!)) {
                        print("Getting new post")
                        self.posts.append(p)
                        self.collectionView.reloadData()
                    }
                })
        }
        
    }
    
    
    func setUpNavBar() {
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 19)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        
        let image = UIImage(named: "logout")
        let logoutButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(logout))
        
        let plusImage = UIImage(named: "plus")
        let plusButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(newPost))
        
        
        self.navigationItem.title = "Feed"
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItem = plusButton
        
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
    
    @objc func logout() {
        UserAuthHelper.logOut {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func newPost() {
        performSegue(withIdentifier: "newsocial", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.tabBarController?.tabBar.isHidden = true
        if segue.identifier == "toDetail" {
            let destVC = segue.destination as! DetailViewController
            let imgHero = "image" + "\(selectedCell!)"
            let eventHero = "event" + "\(selectedCell!)"
            let nameHero = "name" + "\(selectedCell!)"
            let RSVPHero = "RSVP" + "\(selectedCell!)"
            let dateHero = "date" + "\(selectedCell!)"
            let starHero = "star" + "\(selectedCell!)"
            destVC.post = posts[selectedCell!]
            destVC.currentUser = self.currentUser
            destVC.setUpView()
            destVC.image.hero.id = imgHero
            destVC.eventLabel.hero.id = eventHero
            destVC.nameLabel.hero.id = nameHero
            destVC.dateLabel.hero.id = dateHero
            destVC.RSVP.hero.id = RSVPHero
            destVC.starImage.hero.id = starHero
        } else {
            let destVC = segue.destination as! NewSocialViewController
            destVC.currentUser = self.currentUser
        }
        
    }
    
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as! FeedViewCell
        for x in cell.contentView.subviews {
            x.removeFromSuperview()
        }
        cell.awakeFromNib()
        cell.delegate = self
        let post = posts[indexPath.item]
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = post.location
        let search = MKLocalSearch(request: request)
        var lat: Double = 0
        var lon: Double = 0
        var epochTime:TimeInterval = 0
        search.start { response, error in
            guard let response = response else {
                print("There was an error searching for: \(request.naturalLanguageQuery) error: \(error)")
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
        
        var weatherIconImage: UIImage?
        
        cell.id = post.id
        StorageHelper.getProfilePic(id: post.id!).then { (image) -> Void in
            post.image = image
            print("comes 1")
            }.then { _ -> Promise<[String]> in
                 print("comes 2")
                return FirebaseAPIClient.fetchInterested(postID: post.id!)
            }.then { arr -> Promise<Int> in
                print("comes 3")
                if arr[0] == self.currentUser?.id {
                    post.userInterested = true
                }
                return FirebaseAPIClient.fetchRSVP(postID: post.id!)
            }.then { rsvpNum -> Void in
                 print("comes 4")
                post.RSVP = rsvpNum
            }.then { _ -> Promise<String> in
                DarkSkyAPIHelper.findForecast(lat: lat, lon: lon, time: epochTime)
        }.then { (type) -> Void in
            print(type)
            DispatchQueue.main.async {
                cell.bgClearIcon.alpha = 0.3
                cell.bgClearIcon.image = nil
            }
            
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
            weatherIconImage = img
            }.always {
                 print("comes 5")
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
                    cell.bgClearIcon.image = weatherIconImage
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
        
    }
    
    extension FeedViewController: feedViewCellDelegate {
        
        func addModalView(id: String) {
            let list = InterestedListView(frame: CGRect(x: 50, y: 50, width: view.frame.width - 100, height: view.frame.height - 100), id: id)
            let modalView = AKModalView(view: list)
            modalView.dismissAnimation = .FadeOut
            self.navigationController?.view.addSubview(modalView)
            modalView.show()
        }
        
}

