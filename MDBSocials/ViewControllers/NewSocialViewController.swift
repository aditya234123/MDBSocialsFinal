//
//  NewSocialViewController.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/20/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit

class NewSocialViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var nameTextField: UITextField!
    var imageButton: UIButton!
    var imageView: UIImageView!
    var descriptionField: UITextView!
    var dateTextField: UITextField!
    var datePicker: UIDatePicker!
    var descriptionLabel: UILabel!
    var locationTextField: UITextField!
    var tabBarCover: UIView!
    
    var yToGoTo: CGFloat?
    
    //current user saved
    var currentUser: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpNavBar()
        setUpScrollView()
        setUpTextField()
        setUpImage()
        setUpDate()
        setUpDescription()
        setUpLocation()
        /*
        tabBarCover = UIView(frame: CGRect(x: 0, y: view.frame.height - (self.tabBarController?.tabBar.frame.height)!, width: view.frame.width, height: (self.tabBarController?.tabBar.frame.height)!))
        tabBarCover.backgroundColor = .blue
        view.addSubview(tabBarCover)
         */
    }
    
    func setUpNavBar() {
        let image = UIImage(named: "check")
        let postButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(postSelected))
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 19)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationItem.title = "New Post"
        self.navigationItem.rightBarButtonItem = postButton
        
    }
    
    @objc func postSelected() {
        
        if self.nameTextField.text == "" || self.descriptionField.text == "" || self.dateTextField.text == "" || self.imageView.image == nil || self.locationTextField.text == "" {
            let alert = UIAlertController(title: "Can't Post", message: "Please don't leave any fields blank", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        FirebaseAPIClient.createNewPost(id: currentUser?.id, person: (currentUser?.name)!, eventName: self.nameTextField.text!, date: self.dateTextField.text!, description: self.descriptionField.text!, location: self.locationTextField.text!, withBlock: { (key) in
            StorageHelper.uploadMedia(postID: key, image: self.imageView.image!)
            FirebaseAPIClient.createNewInterested(user: self.currentUser!, postID: key)
        })
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpScrollView() {
        scrollView = UIScrollView(frame: view.frame)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 850)
        view.addSubview(scrollView)
        yToGoTo = view.frame.height / 3
    }
    
    func setUpTextField() {
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        let offset = view.frame.width * 2 / 15
        let placeholderColor = UIColor(red: 220/255, green: 221/255, blue: 225/255, alpha: 1.0)
        
        nameTextField = UITextField(frame: CGRect(x: offset, y: 50, width: view.frame.width - offset * 2, height: 50))
        nameTextField.backgroundColor = .clear
        nameTextField.layer.borderColor = barColor.cgColor
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 10
        nameTextField.textColor = barColor
        nameTextField.textAlignment = .center
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name of event", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        nameTextField.tag = 1
        nameTextField.delegate = self
        scrollView.addSubview(nameTextField)
    }
    
    func setUpImage() {
        let offset = view.frame.width * 2 / 15
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        
        imageButton = UIButton(frame: CGRect(x: offset, y: 120, width: view.frame.width - offset * 2, height: 50))
        imageButton.backgroundColor = barColor
        imageButton.setTitle("Select Image", for: .normal)
        imageButton.setTitleColor(.white, for: .normal)
        imageButton.setTitleColor(barColor, for: .highlighted)
        imageButton.setBackgroundColor(.white, for: .highlighted)
        imageButton.layer.borderColor = barColor.cgColor
        imageButton.layer.borderWidth = 1
        imageButton.layer.cornerRadius = 10
        imageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        
        scrollView.addSubview(imageButton)
        
        imageView = UIImageView(frame: CGRect(x: view.frame.width / 2 - 150, y: 190, width: 300, height: 300))
        imageView.backgroundColor = barColor
        imageView.layer.cornerRadius = 10
        scrollView.addSubview(imageView)
    }
    
    @objc func selectImage() {
        
        let alert = UIAlertController(title: "From Where?", message: "", preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alert) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (alert) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setUpDate() {
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        let offset = view.frame.width * 2 / 15
        let placeholderColor = UIColor(red: 220/255, green: 221/255, blue: 225/255, alpha: 1.0)
        
        dateTextField = UITextField(frame: CGRect(x: offset, y: 510, width: view.frame.width - offset * 2, height: 50))
        dateTextField.backgroundColor = .clear
        dateTextField.layer.borderColor = barColor.cgColor
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.cornerRadius = 10
        dateTextField.textColor = barColor
        dateTextField.textAlignment = .center
        dateTextField.attributedPlaceholder = NSAttributedString(string: "Date", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        dateTextField.tag = 1
        dateTextField.delegate = self
        scrollView.addSubview(dateTextField)
    }
    
    func setUpDescription() {
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        let offset = view.frame.width * 2 / 15
        
        descriptionLabel = UILabel(frame: CGRect(x: offset, y: 650, width: view.frame.width, height: 20))
        descriptionLabel.textColor = barColor
        descriptionLabel.text = "Description :"
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        scrollView.addSubview(descriptionLabel)
        
        descriptionField = UITextView(frame: CGRect(x: offset, y: 680, width: view.frame.width - offset * 2, height: 80))
        descriptionField.backgroundColor = .clear
        descriptionField.layer.borderColor = barColor.cgColor
        descriptionField.layer.borderWidth = 1
        descriptionField.textColor = barColor
        descriptionField.layer.cornerRadius = 10
        descriptionField.textAlignment = .center
        descriptionField.textContainer.maximumNumberOfLines = 3
        descriptionField.textContainer.lineBreakMode = .byTruncatingTail
        descriptionField.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        descriptionField.delegate = self
        descriptionField.tag = 5
        
        scrollView.addSubview(descriptionField)
    }
    
    func setUpLocation() {
        let barColor = UIColor(red: 29/255, green: 209/255, blue: 161/255, alpha: 1.0)
        let offset = view.frame.width * 2 / 15
        let placeholderColor = UIColor(red: 220/255, green: 221/255, blue: 225/255, alpha: 1.0)
        
        locationTextField = UITextField(frame: CGRect(x: offset, y: 580, width: view.frame.width - offset * 2, height: 50))
        locationTextField.backgroundColor = .clear
        locationTextField.layer.borderColor = barColor.cgColor
        locationTextField.layer.borderWidth = 1
        locationTextField.layer.cornerRadius = 10
        locationTextField.textColor = barColor
        locationTextField.textAlignment = .center
        locationTextField.attributedPlaceholder = NSAttributedString(string: "Location", attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
        locationTextField.tag = 4
        locationTextField.delegate = self
        scrollView.addSubview(locationTextField)
    }
    
    
}

extension NewSocialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewSocialViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)

        }
        
        let offset = textField.frame.origin.y - yToGoTo!
        if offset > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                let point = CGPoint(x: 0, y: offset)
                self.scrollView.setContentOffset(point, animated: true)
            })
        }
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateTextField.text = dateFormatter.string(from: sender.date)
        dateTextField.adjustsFontSizeToFitWidth = true
        
    }
    
}

extension NewSocialViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let offset = textView.frame.origin.y - yToGoTo!
        if offset > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                let point = CGPoint(x: 0, y: offset)
                self.scrollView.setContentOffset(point, animated: true)
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
}
