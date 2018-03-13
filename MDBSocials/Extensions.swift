//
//  Extensions.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/19/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

extension UITextField {
    func setUpLogInTextFields() {
        self.backgroundColor = .clear
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.textColor = .white
        self.textAlignment = .center
    }
}

extension UIButton {
    
    func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(colorImage, for: state)
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
