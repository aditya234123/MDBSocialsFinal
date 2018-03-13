//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/22/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var eventCoverView: UIView!
    var dateCoverView: UIView!
    
    var currentUser: UserModel?
    
    var post: Post?
    var image: UIImageView!
    var eventLabel: UILabel!
    var nameLabel: UILabel!
    var dateLabel: UILabel!
    var starImage: UIButton!
    var RSVP: UILabel!
    var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpView() {
        self.hero.isEnabled = true
        setUpNav()
        setUpImage()
        setUpText()
    }
    
    func setUpNav() {
        let image = UIImage(named: "pin")
        let pin = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toMap))
        self.navigationItem.rightBarButtonItem = pin
    }
    
    @objc func toMap() {
        performSegue(withIdentifier: "toMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! MapViewController
        destVC.queryString = post?.location
    }
    
    func setUpImage() {
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        image.image = post?.image
        view.addSubview(image)
    }
    
    func setUpText() {
        
        //rgb(52, 73, 94)
        //rgb(149, 165, 166)
        let mainTextColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
        let secondTextColor = UIColor(red: 149/255, green: 165/255, blue: 166/255, alpha: 1.0)
        
        eventLabel = UILabel(frame: CGRect(x: 10, y: 7.5, width: view.frame.width - 50, height: 30))
        eventLabel.text = post?.eventName
        eventLabel.textColor = .white
        eventLabel.font = UIFont(name: "HelveticaNeue-Light", size: 19)
        
        //rgb(44, 62, 80)
        let coverColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        eventCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        eventCoverView.backgroundColor = coverColor
        view.addSubview(eventCoverView)
        view.addSubview(eventLabel)
        
        nameLabel = UILabel(frame: CGRect(x: 10, y: view.frame.width + 10, width: view.frame.width, height: 30))
        nameLabel.textColor = mainTextColor
        nameLabel.text = "Posted by: " + (post?.personName)!
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        view.addSubview(nameLabel)
        
        dateCoverView = UIView(frame: CGRect(x: view.frame.width / 2 - 15, y: view.frame.width - 37, width: view.frame.width / 2 + 30, height: 37))
        dateCoverView.backgroundColor = coverColor
        view.addSubview(dateCoverView)
        
        dateLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 15, y: view.frame.width - 30, width: view.frame.width / 2 + 30, height: 30))
        dateLabel.text = post?.date
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        dateLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(dateLabel)
        
        descriptionLabel = UILabel(frame: CGRect(x: 10, y: view.frame.width + 45, width: view.frame.width - 20, height: 100))
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byCharWrapping
        descriptionLabel.text = post?.description
        descriptionLabel.sizeToFit()
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        descriptionLabel.textColor = secondTextColor
        view.addSubview(descriptionLabel)
        
        let star = UIImage(named: "star")
        let star2 = UIImage(named: "star2")
        
        starImage = UIButton(frame: CGRect(x: view.frame.width - 80, y: view.frame.height - 110, width: 30, height: 30))
        if (post?.userInterested!)! {
            starImage.setImage(star2, for: .normal)
            starImage.isEnabled = false
        } else {
            starImage.setImage(star, for: .normal)
            starImage.setImage(star2, for: .highlighted)
            starImage.addTarget(self, action: #selector(starSelected), for: .touchUpInside)
        }
        view.addSubview(starImage)
        
        RSVP = UILabel(frame: CGRect(x: view.frame.width - 45, y: view.frame.height - 110, width: 40, height: 30))
        RSVP.text = "\(post!.RSVP!)"
        view.addSubview(RSVP)
        
        
    }
    
    @objc func starSelected() {
        let star2 = UIImage(named: "star2")
        starImage.setImage(star2, for: .normal)
        starImage.isEnabled = false
        let rsvpIncr = (post?.RSVP)! + 1
        RSVP.text = "\(rsvpIncr)"
        
        FirebaseAPIClient.eventRSVP(postID: (post?.id)!, user: currentUser!)
        
    }

}
