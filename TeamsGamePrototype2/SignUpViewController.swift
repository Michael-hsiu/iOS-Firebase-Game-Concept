//
//  SignUpViewController.swift
//  TeamsGamePrototype2
//
//  Created by Michael Hsiu on 12/1/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var userImageView: UIImageView! {
        didSet{
            userImageView.isUserInteractionEnabled = true
        }
    }

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var teamTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var authService = AuthService()
    
    @IBAction func signUpAction(_ sender: Any) {

        self.activateLoginAlertIndicator()
        
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let team = teamTextField.text!
        let pictureData = UIImageJPEGRepresentation(self.userImageView.image!, 0.8)
        
        
        if finalEmail.isEmpty || username.isEmpty || password.isEmpty || team.isEmpty {
            
            // self.activateLoginAlertIndicator()
            self.deactivateLoginAlertIndicator()
            
            self.view.endEditing(true)
            
            // Tell them that they haven't filled in all the necessary fields!!
            let alertController = UIAlertController(title: "Alert!", message: "There are required fields left :O", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
            
        
        } else if password.characters.count < 6 {
            
            self.deactivateLoginAlertIndicator()
            
            // Tell them that their password is too short!
            let alertController = UIAlertController(title: "Alert!", message: "The password must be 6 characters or longer!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        
        
        } else {
            print("I GOT HERE!")
            
            self.activateLoginAlertIndicator()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            //self.view.endEditing(true)
            
            authService.signUp(username: username, email: finalEmail, password: password, team: team, pictureData: pictureData as NSData!)
            
            print("PAST SIGNUP!!")
            

            self.deactivateLoginAlertIndicator()
            
        }
        
        
    }
    
    func activateLoginAlertIndicator() {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        print("Activity Indicator activated!!")
    }
    
    func deactivateLoginAlertIndicator() {
        activityIndicator.stopAnimating()
        print("Activity Indicator deactivated!!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGestureRecognizersToDismissKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func choosePictureAction(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add a Profile Picture", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func setGestureRecognizersToDismissKeyboard() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.choosePictureAction(sender:)))
        imageTapGesture.numberOfTapsRequired = 1
        userImageView.addGestureRecognizer(imageTapGesture)
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        // Creating Swipe Gesture to dismiss Keyboard
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard(gesture:)))
        swipDown.direction = .down
        view.addGestureRecognizer(swipDown)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userImageView.image = image
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.userImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Dismissing the Keyboard with the Return Keyboard Button
    func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
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
