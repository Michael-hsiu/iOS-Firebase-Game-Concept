//
//  LogInViewController.swift
//  TeamsGamePrototype1
//
//  Created by Michael Hsiu on 11/28/16.
//  Copyright © 2016 Michael Hsiu. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {



    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    var authService = AuthService()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func logInAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        
        
        let email = emailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!
        

        
        if finalEmail.characters.count < 8 || finalEmail.isEmpty || password.isEmpty {
            
            
            // Invalid login conditions
            let alertController = UIAlertController(title: "Alert!", message: "Incorrect email/password!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            // Log 'em in
            
            
            activateLoginAlertIndicator()
            
            authService.logIn(email: finalEmail, password: password)
            
            deactivateLoginAlertIndicator()
            
        }
        
        //if userName.text == "Test" {
            //let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu")
            
            //present(vc, animated: true, completion: nil)
        //}
    }
    
    func activateLoginAlertIndicator() {

        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func deactivateLoginAlertIndicator() {
        activityIndicator.stopAnimating()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindToLogInViewController(segue:UIStoryboardSegue) {
        
        print("I am unwinding!")
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
