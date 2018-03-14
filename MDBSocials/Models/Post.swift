//
//  Post.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/21/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
import ObjectMapper

class Post {
    

    required init?(map: Map) {
        mapping(map: map)
    }
    
    
    func mapping(map: Map) {
        id <- map["ID"]
        personName <- map["Person"]
        eventName <- map["Event"]
        RSVP <- map["RSVP"]
        date <- map["Date"]
        description <- map["Description"]
        location <- map["Location"]
        userInterested = false
    }


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

}
