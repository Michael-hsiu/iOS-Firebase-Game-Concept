//
//  UserProfileViewController.swift
//  TeamsGamePrototype2
//
//  Created by Michael Hsiu on 12/1/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UserProfileViewController: UIViewController {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var teamLabel: UILabel!


    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage {
        return FIRStorage.storage()
    }
    
    func loadUserInfo() {
        
        let userRef = databaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        
        userRef.observe(.value, with: { (snapshot) in
            
            let user = User(snapshot: snapshot)
            self.emailLabel.text = "Email: " + user.email!
            self.usernameLabel.text = "Username: " + user.username
            self.teamLabel.text = user.team    // Not working
            
            let imageURL = user.photoURL!
            
            self.storageRef.reference(forURL: imageURL).data(withMaxSize: 15 * 1024 * 1024, completion: { (imgData, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    
                    DispatchQueue.main.async {      // Better, faster way of updating user profile UI
                        if let data = imgData {
                            self.userImageView.image = UIImage(data: data)
                        }
                    }
                    
                }
            })
            
        }) { (error) in
            print(error.localizedDescription) }
        
        
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        
        if FIRAuth.auth()?.currentUser != nil {
            // There is a user signed in
            do {
                try? FIRAuth.auth()?.signOut()
                
                if FIRAuth.auth()?.currentUser == nil {
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LogInViewController
                    self.present(loginVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
