//
//  EmptyViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 3/3/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkLoggedIn()
    }
    
    func checkLoggedIn() {
        UserAuthHelper.isUserLoggedIn { (bool) in
            if bool {
                log.info("User logged in already.")
                self.performSegue(withIdentifier: "doesntNeedLogin", sender: self)
            } else {
                log.info("User not logged in.")
                self.performSegue(withIdentifier: "NeedsLogin", sender: self)
            }
        }
    }

}
