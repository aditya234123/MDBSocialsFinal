//
//  UserModel.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/21/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class UserModel {

    var id: String?
    var name: String?
    var username: String?
    var email: String?
    
    init(name: String, username: String, email: String, id: String) {
        self.name = name
        self.username = username
        self.email = email
        self.id = id
    }
    
}
