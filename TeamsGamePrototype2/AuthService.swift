//
//  AuthService.swift
//  TeamsGamePrototype2
//
//  Created by Michael Hsiu on 12/1/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct AuthService {
    var dataBaseReference: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageReference: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    // 1 - Signup function - user, email, password, team
    func signUp (username: String, email: String, password: String, team: String, pictureData: NSData!){
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                self.setUserInfo(user: user, username: username, email: email, password: password, team: team, pictureData: pictureData)
            }
        })
    }
    
    // 2 - Save User Profile Picture to Firebase Storage, assign to new user a username and Photo URL
    
    private func setUserInfo(user: FIRUser!, username: String, email: String, password: String, team: String, pictureData: NSData!) {
        
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        let imageRef = storageReference.child(imagePath)
        
        let metaData = FIRStorageMetadata()
        
        metaData.contentType = "image/jpeg"
        
        // Uploading picture data
        imageRef.put(pictureData as Data, metadata: metaData, completion: { (newMetaData, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = username
                
                if let photoURL = newMetaData!.downloadURL() {
                    changeRequest.photoURL = photoURL
                }
                
                changeRequest.commitChanges(completion: { (error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        self.saveUserInfo(user: user, username: username, email: email, password: password, team: team)
                    }
                })
            }
        })
    }
    
    // 3 - Save User Info to Firebase Database
    private func saveUserInfo(user: FIRUser!, username: String, email: String, password: String, team: String) {
        let userInfo  = ["email": user.email!, "username": username, "password": password, "team": team, "uid": user.uid, "photoURL": String(describing: user.photoURL!)]
        
        let userRef = dataBaseReference.child("users").child(user.uid)
        
        userRef.setValue(userInfo) { (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("User info saved successfully!")
                self.logIn(email: user.email!, password: password)
            }
        }
    }
    
    // 4 - Logging in the user function
    public func logIn(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let user = user {
                    print("\(user.displayName!) has logged in successfully!")
                    
                    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDel.logUser()
                }
            }
            
            UIApplication.shared.endIgnoringInteractionEvents()
        })
    }
    
    
    
    
    
    
    
}
