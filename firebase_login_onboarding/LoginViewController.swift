//
//  LoginViewController.swift
//  firebase_login_onboarding
//
//  Created by Marquavious on 5/27/17.
//  Copyright © 2017 Marquavious Draggon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var verificationStackView: UIStackView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var mainStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        logIn()
    }
    
    func logIn(){
        startLoader()
        guard let email = emailTextField.text, !email.isEmpty else {
            self.displayAlert("Error", message:"Must enter a valid email")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.displayAlert("Error", message:"Must enter a valid password")
            return
        }
        
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{ self.displayAlert("Error", message: (error?.localizedDescription)!)
                
                return
            }

            if (FIRAuth.auth()?.currentUser!.isEmailVerified) == true {
                print("VERIFIED")
            }else{
                self.displayAlert("Error", message: "Pleas verify your email you signed up with!")
            }
        })
        
        
    }
    
    func startLoader(){
        verificationStackView.alpha = 1
        activityIndicator.startAnimating()
        mainStackView.alpha = 0
    }
    
    func endLoader(){
        verificationStackView.alpha = 0
        activityIndicator.stopAnimating()
        mainStackView.alpha = 1
    }

    func displayAlert(_ title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in }))
        self.present(alert, animated: true, completion: {
            self.endLoader()
        })
    }
}
