//
//  UserModel.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/21/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
import ObjectMapper

class UserModel: Mappable {
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        name <- map["name"]
        username <- map["username"]
        email <- map["email"]
    }
    

    var id: String?
    var name: String?
    var username: String?
    var email: String?
    
}
