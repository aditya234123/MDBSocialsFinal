//
//  SignupViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/19/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var bg: UIView!
    var signupButton: UIButton!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var selectImageButton: UIButton!
    var imageView: UIImageView!
    
    var yToGoTo: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupBg()
        setupScrollView()
        setupSignUpButton()
        setUpTextFields()
        setUpProfilePic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setUpProfilePic() {
        let offset = self.preferredContentSize.width * 2 / 15
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)

        selectImageButton = UIButton(frame: CGRect(x: offset, y: 330, width: self.preferredContentSize.width - offset * 2, height: 50))
        selectImageButton.backgroundColor = barColor
        selectImageButton.setTitle("Select Image", for: .normal)
        selectImageButton.setTitleColor(.white, for: .normal)
        selectImageButton.setTitleColor(barColor, for: .highlighted)
        selectImageButton.setBackgroundColor(.white, for: .highlighted)
        selectImageButton.layer.borderColor = barColor.cgColor
        selectImageButton.layer.borderWidth = 1
        selectImageButton.layer.cornerRadius = 10
        selectImageButton.clipsToBounds = true
        selectImageButton.addTarget(self, action: #selector(addProfilePic), for: .touchUpInside)
        scrollView.addSubview(selectImageButton)
        
        imageView = UIImageView(frame: CGRect(x: offset, y: 400, width: self.preferredContentSize.width - offset * 2 , height: self.preferredContentSize.width - offset * 2))
        imageView.backgroundColor = barColor
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        
    }
    
    @objc func addProfilePic() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func setupBg() {
        bg = UIView(frame: view.frame)
        bg.backgroundColor = UIColor(red: 84/255, green: 160/255, blue: 255/255, alpha: 1.0)
        view.addSubview(bg)
    }
    
    func setupScrollView() {
        let offset = self.preferredContentSize.width * 2 / 15
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.preferredContentSize.width, height: self.preferredContentSize.height))
        scrollView.contentSize = CGSize(width: self.preferredContentSize.width, height: 400 + self.preferredContentSize.width - offset * 2 + 80)
        view.addSubview(scrollView)
        
        yToGoTo = self.preferredContentSize.height / 3
    }
    
    func setupSignUpButton() {
        let offset = self.preferredContentSize.width * 2 / 15
        signupButton = UIButton(frame: CGRect(x: 0, y: 400 + self.preferredContentSize.width - offset * 2 + 20, width: self.preferredContentSize.width, height: 60))
        let buttonColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        signupButton.backgroundColor = buttonColor
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        let selectedColor = UIColor(red: 255/255, green: 159/255, blue: 243/255, alpha: 1.0)
        signupButton.setBackgroundColor(selectedColor, for: .highlighted)
        signupButton.addTarget(self, action: #selector(signupClicked), for: .touchUpInside)
        scrollView.addSubview(signupButton)
    }
    
    @objc func signupClicked() {
        if (emailTextField.text == "" || passwordTextField.text == "" || nameTextField.text == "" || usernameTextField.text == "") {
            let alert = UIAlertController(title: "Can't login", message: "Please don't leave any fields blank", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            OperationQueue.main.addOperation {
                self.present(alert, animated: true, completion: nil)
                self.view.endEditing(true)
            }
            return
        }
        UserAuthHelper.createUser(email: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != "" {
                let alert = UIAlertController(title: "Can't Sign Up", message: error, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                OperationQueue.main.addOperation {
                    self.present(alert, animated: true, completion: nil)
                    self.view.endEditing(true)
                }
            } else {
                self.dismiss(animated: true, completion: nil)
                self.presentingViewController?.childViewControllers[0].performSegue(withIdentifier: "loggedin", sender: self)
                FirebaseAPIClient.createNewUser(id: user!.uid, name: self.nameTextField.text!, email: self.emailTextField.text!, username: self.usernameTextField.text!)
                //upload profile pic
                if self.imageView.image != nil {
                    StorageHelper.uploadMedia(postID: (user?.uid)!, image: self.imageView.image!)
                } else {
                //can set up default.
                    let image = UIImage(named: "defaultprofile")
                    StorageHelper.uploadMedia(postID: (user?.uid)!, image: image!)
                }
            }
        }
    }
    
    func setUpTextFields() {
        let offset = self.preferredContentSize.width * 2 / 15
        let placeholderColor = UIColor(red: 220/255, green: 221/255, blue: 225/255, alpha: 1.0)
        
        nameTextField = UITextField(frame: CGRect(x: offset, y: 50, width: self.preferredContentSize.width - offset * 2, height: 50))
        nameTextField.setUpLogInTextFields()
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        nameTextField.tag = 1
        nameTextField.delegate = self
        scrollView.addSubview(nameTextField)
        
        usernameTextField = UITextField(frame: CGRect(x: offset, y: 120, width: self.preferredContentSize.width - offset * 2, height: 50))
        usernameTextField.setUpLogInTextFields()
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        usernameTextField.tag = 2
        usernameTextField.delegate = self
        scrollView.addSubview(usernameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: offset, y: 190, width: self.preferredContentSize.width - offset * 2, height: 50))
        emailTextField.setUpLogInTextFields()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        emailTextField.tag = 3
        emailTextField.delegate = self
        scrollView.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: offset, y: 260, width: self.preferredContentSize.width - offset * 2, height: 50))
        passwordTextField.setUpLogInTextFields()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tag = 4
        passwordTextField.delegate = self
        scrollView.addSubview(passwordTextField)
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let next = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            next.becomeFirstResponder()
        } else {
            signupClicked()
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


extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
}
