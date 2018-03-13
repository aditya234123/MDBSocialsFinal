//
//  Post.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/21/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
//import ObjectMapper

class Post {
    
    /* IMPLEMENT LATER

    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        id <- map["id"]
        personName <- map["personName"]
        eventName <- map["personName"]
        image <- map["image"]
        RSVP <- map["RSVP"]
        date <- map["date"]
        description <- map["description"]
        userInterested <- map["userInterested"]
        location <- map["location"]
    }
 
     */

    var id: String?
    var personName: String?
    var eventName: String?
    var image: UIImage?
    var RSVP: Int?
    var date: String?
    var description: String?
    var userInterested: Bool?
    var location: String?
    var iconImg: UIImage?
    
    init(id: String, postDict: [String:Any?]?) {
        self.id = id
        if postDict != nil {
            if let person = postDict!["Person"] as? String {
                self.personName = person
            }
            if let event = postDict!["Event"] as? String {
                self.eventName = event
            }
            if let description = postDict!["Description"] as? String {
                self.description = description
            }
            if let date = postDict!["Date"] as? String {
                self.date = date
            }
            if let RSVP = postDict!["RSVP"] as? Int {
                self.RSVP = RSVP
            }
            if let location = postDict!["Location"] as? String {
                self.location = location
            }
            userInterested = false
        }
    }

}
