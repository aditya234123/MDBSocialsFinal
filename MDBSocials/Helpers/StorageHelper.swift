//
//  StorageHelper.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/21/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import Firebase
import FirebaseStorage
import PromiseKit

class StorageHelper {
    
    static func uploadMedia(postID: String, image: UIImage) -> Promise<Void> {
        return Promise {
            fulfill, reject in
            
            let storage = Storage.storage().reference().child(postID)
            if let uploadData = UIImageJPEGRepresentation(image, 0.3) {
                storage.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        reject(error!)
                    } else {
                        fulfill(())
                    }
                }
            }
            
        }
        
    }
    
    static func getProfilePic(id: String, withBlock: @escaping (UIImage) -> ()) {
        let ref = Storage.storage().reference().child(id)
        ref.getData(maxSize: 1 * 4096 * 4096) { data, error in
            if let error = error {
                getProfilePic(id: id, withBlock: { (image) in
                    withBlock(image)
                })
            } else {
                let image = UIImage(data: data!)
                withBlock(image!)
            }
        }
    }
    
}
