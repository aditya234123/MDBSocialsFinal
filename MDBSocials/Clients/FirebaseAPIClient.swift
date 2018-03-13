//
//  FirebaseAPIClient.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/21/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import Firebase
import FirebaseDatabase
import PromiseKit

class FirebaseAPIClient {

    static func createNewUser(id: String, name: String, email: String, username: String) {
        let usersRef = Database.database().reference().child("Users")
        let newUser = ["name": name, "email": email, "username": username, "Interested" : ""]
        let childUpdates = ["/\(id)/": newUser]
        usersRef.updateChildValues(childUpdates)
    }
    
    static func createNewPost(id: String?, person: String, eventName: String, date: String, description: String, location: String, withBlock: @escaping (String) -> ()) {
        let ref = Database.database().reference()
        let key = ref.child("Posts").childByAutoId().key
        let post = ["Person": person, "Event": eventName, "RSVP": 0, "Date": date, "Description": description, "Location" : location] as [String : Any]
        let childUpdates = ["/Posts/\(key)": post]
        ref.updateChildValues(childUpdates)
        withBlock(key)
        
        let otherChanges = [key : ""] as [String : String]
        let moreChildUpdates = ["/Users/" + id! + "/Interested": otherChanges]
        ref.updateChildValues(moreChildUpdates)
    }
    
    static func createNewInterested(user: UserModel, postID: String){
        let ref = Database.database().reference()
        let key = ref.child("Interested").childByAutoId().key
        //fix.
        ref.child("Interested").updateChildValues([postID : [user.id! : user.name!]])
    }
    
    
    static func fetchUser(id: String, withBlock: @escaping (NSDictionary) -> ()) {
        let ref = Database.database().reference()
        ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            withBlock(dict!)
            
        })
    }
    
    static func fetchPosts(withBlock: @escaping (Post) -> ()) {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            withBlock(post)
        })
    }
    
    static func fetchInterested(postID: String, withBlock: @escaping ([String]) -> ()) {

        let ref = Database.database().reference().child("Interested").child(postID)
        ref.observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key as! String
            let name = snapshot.value as! String
            let dict = [id, name]
            withBlock(dict)
        })
    }
    
    static func fetchRSVP(postID: String, withBlock: @escaping (Int) -> ()) {
        let ref = Database.database().reference()
        ref.child("Posts").child(postID).observe(.childChanged, with: { (snapshot) in
            withBlock(snapshot.value as! Int)
        })
    }
    
    static func eventRSVP(postID: String, user: UserModel) {
        let ref = Database.database().reference()
        ref.child("Posts").child(postID).runTransactionBlock({ (currentData:MutableData) -> TransactionResult in
            if var post = currentData.value as? [String: AnyObject] {
                
                var rsvpCount = post["RSVP"] as? Int ?? 0
                rsvpCount += 1
                post["RSVP"] = rsvpCount as AnyObject?
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.abort()
        })
        ref.child("Interested").child(postID).setValue([user.id! : user.name!])
        let post = [postID : ""] as [String : String]
        let childUpdates = ["/Users/"+user.id!+"/Interested": post]
        ref.updateChildValues(childUpdates)
    }
    
    
    static func getUserInterests(userID: String, withBlock: @escaping (String) -> ()) {
        let ref = Database.database().reference().child("Users").child(userID).child("Interested")
        ref.observe(.childAdded, with: { (snapshot) in
            let id = snapshot.key as! String
            withBlock(id)
        })
    }
    
    static func getPostInfo(postID: String, withBlock: @escaping (Post) -> ()) {
        
        let ref = Database.database().reference().child("Posts")
        ref.child(postID).observeSingleEvent(of: .value) { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            withBlock(post)
        }
        
        
    }

    /* IMPLEMENT LATER
    
    static func fetchPostsAtOnce() -> Promise<[Post]> {
        
         let ref = Database.database().reference().child("Posts")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
        }
        
    }
    
    */
    
}
