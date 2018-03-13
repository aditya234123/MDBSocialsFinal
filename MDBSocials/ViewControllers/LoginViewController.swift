//
//  LoginViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/19/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var bgImage: UIImageView!
    var welcomeLabel: UILabel!
    var detailsLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var registerButton: UIButton!
    
    var activeTextField: UITextField?
    
    var yToGoTo: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpBg()
        setupScrollView()
        setUpLabels()
        setUpTextFields()
        setUpLoginButton()
        setUpRegister()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: view.frame)
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        scrollView.isScrollEnabled = false
        view.addSubview(scrollView)
        yToGoTo = view.frame.height / 3
    }

    func setUpBg() {
        bgImage = UIImageView(frame: view.frame)
        bgImage.image = UIImage(named: "bg")
        view.addSubview(bgImage)
    }
    
    func setUpLabels() {
        welcomeLabel = UILabel(frame: CGRect(x: 30, y: view.frame.height / 3 - 70, width: view.frame.width - 60, height: 50))
        welcomeLabel.text = "MDBSocials"
        welcomeLabel.textColor = .white
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont(name: "KohinoorDevanagari-Light", size: 47)
        scrollView.addSubview(welcomeLabel)
        
        detailsLabel = UILabel(frame: CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 3 - 40, width: 200, height: 100))
        detailsLabel.text = "Start exploring all the upcoming events"
        detailsLabel.textColor = .white
        detailsLabel.textAlignment = .center
        detailsLabel.lineBreakMode = .byWordWrapping
        detailsLabel.numberOfLines = 0;
        detailsLabel.font = UIFont(name: "KohinoorDevanagari-Light", size: 13)
        scrollView.addSubview(detailsLabel)
    }
    
    func setUpTextFields() {
        let offset = view.frame.width * 2 / 15
        let placeholderColor = UIColor(red: 220/255, green: 221/255, blue: 225/255, alpha: 1.0)
        
        emailTextField = UITextField(frame: CGRect(x: offset, y: view.frame.height / 3 + 40, width: view.frame.width - offset * 2, height: 50))
        emailTextField.setUpLogInTextFields()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        emailTextField.tag = 1
        emailTextField.delegate = self
        scrollView.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: offset, y: view.frame.height / 3 + 110, width: view.frame.width - offset * 2, height: 50))
        passwordTextField.setUpLogInTextFields()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "•••••••••", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tag = 2
        passwordTextField.delegate = self
        scrollView.addSubview(passwordTextField)
    }
    
    func setUpLoginButton() {
        let offset = view.frame.width * 2 / 15
        
        loginButton = UIButton(frame: CGRect(x: offset, y: view.frame.height / 3 + 180, width: view.frame.width - offset * 2, height: 50))
        let bg = UIColor(red: 255/255, green: 107/255, blue: 129/255, alpha: 1.0)
        loginButton.backgroundColor = bg
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.textAlignment = .center
        loginButton.layer.cornerRadius = 10

        let seletedColor = UIColor(red: 0/255, green: 210/255, blue: 211/255, alpha: 1.0)
        loginButton.setBackgroundColor(seletedColor, for: .highlighted)
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(loginClicked), for: .touchUpInside)
        scrollView.addSubview(loginButton)
    }
    
    @objc func loginClicked() {
        if (emailTextField.text == "" || passwordTextField.text == "") {
            let alert = UIAlertController(title: "Can't login", message: "Please don't leave any fields blank", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            OperationQueue.main.addOperation {
                self.present(alert, animated: true, completion: nil)
                self.view.endEditing(true)
            }
            return
        }
        UserAuthHelper.logIn(email: emailTextField.text!, password: passwordTextField.text!) { (user, errorInfo) in
            if errorInfo != "" {
                let alert = UIAlertController(title: "Can't login ", message: errorInfo, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                OperationQueue.main.addOperation {
                    self.present(alert, animated: true, completion: nil)
                    self.view.endEditing(true)
                }
            } else {
                self.performSegue(withIdentifier: "loggedin", sender: self)
            }
        }
    }
    
    func setUpRegister() {
        let offset = view.frame.width * 2 / 15
        let seletedColor = UIColor(red: 0/255, green: 210/255, blue: 211/255, alpha: 1.0)
        
        registerButton = UIButton(frame: CGRect(x: view.frame.width - offset - 70, y: view.frame.height / 3 + 250, width: 70, height: 50))
        registerButton.backgroundColor = .clear
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "KohinoorDevanagari-Light", size: 14)
        registerButton.setTitleColor(seletedColor, for: .highlighted)
        registerButton.addTarget(self, action: #selector(registerClicked), for: .touchUpInside)
        scrollView.addSubview(registerButton)
    }
    
    @objc func registerClicked() {
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signup")
        signupVC.modalPresentationStyle = UIModalPresentationStyle.popover
        signupVC.preferredContentSize = CGSize(width: view.frame.width - 50, height: view.frame.height - 150)
        
        let popOver = signupVC.popoverPresentationController!
        popOver.delegate = self
        popOver.permittedArrowDirections = .up
        popOver.sourceView = self.view
        popOver.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY - (view.frame.height - 100) / 2, width: 0, height: 0)
        
        present(signupVC, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let next = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            next.becomeFirstResponder()
        } else {
            loginClicked()
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let offset = textField.frame.origin.y - yToGoTo!
        if offset > 0 {
            let point = CGPoint(x: 0, y: offset)
            self.scrollView.setContentOffset(point, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let point = CGPoint(x: 0, y: 0)
        self.scrollView.setContentOffset(point, animated: true)
        
    }
    
}

