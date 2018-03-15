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
import ObjectMapper

class FirebaseAPIClient {

    static func createNewUser(id: String, name: String, email: String, username: String) {
        let usersRef = Database.database().reference().child("Users")
        let newUser = ["name": name, "email": email, "username": username, "Interested" : ""]
        let childUpdates = ["/\(id)/": newUser]
        usersRef.updateChildValues(childUpdates)
    }
    
    static func createNewPost(id: String?, person: String, eventName: String, date: String, description: String, location: String) -> Promise<String> {
        return Promise { fulfill, reject in
            let ref = Database.database().reference()
            let key = ref.child("Posts").childByAutoId().key
            let post = ["Person": person, "Event": eventName, "RSVP": 1, "Date": date, "Description": description, "Location" : location] as [String : Any]
            let childUpdates = ["/Posts/\(key)": post]
            ref.updateChildValues(childUpdates)
            let otherChanges = [""] as [String]
            let moreChildUpdates = ["/Users/" + id! + "/Interested/" + "\(key)": otherChanges]
            ref.updateChildValues(moreChildUpdates)
            fulfill(key)
        }
    }
    
    static func createNewInterested(user: UserModel, postID: String) -> Promise<String> {
        return Promise {
            fulfill, reject in
            let ref = Database.database().reference()
            ref.child("Interested").updateChildValues([postID : [user.id! : user.name!]])
            fulfill(postID)
        }
    }
    
    
    static func fetchUser(id: String)  -> Promise<UserModel> {
        return Promise {
            fulfill, reject in
            let ref = Database.database().reference()
            ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                var dict = snapshot.value as! [String : Any]
                dict["ID"] = id
                let user = UserModel(map: Map.init(mappingType: .fromJSON, JSON: dict))
                fulfill(user!)
            })
        }
    }
    
    static func fetchAllPosts() -> Promise<[Post]> {
        return Promise {
            fulfill, reject in
            let ref = Database.database().reference()
            ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
                var posts = [Post]()
                for snap in snapshot.children {
                    let snapConverted = snap as! DataSnapshot
                    var dict = snapConverted.value as! [String : Any]
                    dict["ID"] = snapConverted.key
                    let post = Post(map: Map.init(mappingType: .fromJSON, JSON: dict))
                    //let post = Post(id: snapConverted.key , postDict: snapConverted.value as! [String : Any]?)
                    posts.append(post!)
                }
                fulfill(posts)
            })
           
        }
    }
    
    static func fetchNewPosts(withBlock: @escaping (Post) -> ()) {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded) { (snapshot) in
            var dict = snapshot.value as! [String : Any]
            dict["ID"] = snapshot.key
            let post = Post(map: Map.init(mappingType: .fromJSON, JSON: dict))
            withBlock(post!)
        }
    }
    
    static func fetchNewInterests(userID: String, withBlock: @escaping (String) -> ()) {
        let ref = Database.database().reference()
        ref.child("Users").child(userID).child("Interested").observe(.childAdded) { (snapshot) in
            withBlock(snapshot.key)
        }
    }
    
    static func fetchInterested(postID: String, names: Bool) -> Promise<[String]> {
        return Promise {
            fulfill, reject in
            let ref = Database.database().reference()
            ref.child("Interested").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                var ids = [String]()
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    if !names {
                        ids.append(snap.key)
                    } else {
                        ids.append(snap.value as! String)
                    }
                }
                fulfill(ids)
            })
        }
    }
    
    static func fetchRSVP(postID: String) -> Promise<Int> {
        return Promise {
            fulfill, reject in
            let ref = Database.database().reference()
            ref.child("Posts").child(postID).observe(.value, with: { (snapshot) in
                let dict = snapshot.value as! [String : Any]
                fulfill(dict["RSVP"] as! Int)
            })
        }
    }
    
    static func fetchRSVPChange(postID: String, withBlock: @escaping (Int) -> ()) {
            let ref = Database.database().reference()
            ref.child("Posts").child(postID).observe(.childChanged, with: { (snapshot) in
                withBlock(snapshot.value as! Int)
            })
    }
    
    static func eventRSVP(postID: String, val: Int, user: UserModel) {
        let ref = Database.database().reference()
        ref.child("Posts").child(postID).runTransactionBlock({ (currentData:MutableData) -> TransactionResult in
            if var post = currentData.value as? [String: AnyObject] {
                
                var rsvpCount = post["RSVP"] as? Int ?? 0
                rsvpCount += val
                post["RSVP"] = rsvpCount as AnyObject?
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.abort()
        })
        if val == 1 {
            ref.child("Interested").child(postID).child(user.id!).setValue(user.name!)
            let otherChanges = [""] as [String]
            let moreChildUpdates = ["/Users/" + user.id! + "/Interested/" + "\(postID)": otherChanges]
            ref.updateChildValues(moreChildUpdates)
        } else {
            //remove
            ref.child("Interested").child(postID).child(user.id!).removeValue(completionBlock: {
                error, _ in
                log.warning(error)
            })
            ref.child("Users").child(user.id!).child("Interested").child(postID).removeValue(completionBlock: { (error, _) in
                log.warning(error)
            })
        }
    }
    
    
    static func getUserInterests(userID: String) -> Promise<[String]> {
        return Promise {
            fulfill, reject in
            let ref = Database.database().reference().child("Users").child(userID).child("Interested")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                var ids = [String]()
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    ids.append(snap.key)
                }
                fulfill(ids)
            }
        }
    }
    
    static func getPostInfo(postID: String, withBlock: @escaping (Post) -> ()) {
        
        let ref = Database.database().reference().child("Posts")
        ref.child(postID).observeSingleEvent(of: .value) { (snapshot) in
            var dict = snapshot.value as! [String : Any]
            dict["ID"] = snapshot.key
            let post = Post(map: Map.init(mappingType: .fromJSON, JSON: dict))
            withBlock(post!)
        }
        
    }
    
}
