//
//  User.swift
//  TeamsGamePrototype2
//
//  Created by Michael Hsiu on 12/1/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct User {
    
    var username: String!
    var email: String?
    var team: String?
    var password: String!
    var photoURL: String!
    var uid: String!
    var ref: FIRDatabaseReference?
    var key: String?
    
    init(snapshot: FIRDataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        
        username = (snapshot.value! as? NSDictionary)?["username"] as! String
        email = (snapshot.value! as! NSDictionary)["email"] as? String
        team = (snapshot.value! as! NSDictionary)["team"] as? String
        uid = (snapshot.value! as! NSDictionary)["uid"] as! String
        photoURL = (snapshot.value! as! NSDictionary)["photoURL"] as! String
        
    }
    

    
    
}
