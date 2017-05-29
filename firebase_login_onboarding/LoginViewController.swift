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
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var verificationStackView: UIStackView!
    @IBOutlet weak var verificationMessageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEmailTextField()
        setUpNotifications()
        hideKeyboardWhenTappedAround()
        signUpButton.addCornerRadius(4.5)
        signUpButton.alpha = 0.7
        signUpButton.backgroundColor = UIColor.lightGray
        signUpButton.isUserInteractionEnabled = false
        addSwipeDownFunction()
    }
    
    func setUpNotifications(){
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if emailTextField.hasText && passwordTextField.hasText{
        UIView.animate(withDuration: 0.1, animations: {
            self.signUpButton.alpha = 1
            self.signUpButton.isUserInteractionEnabled = true
            self.signUpButton.backgroundColor = UIColor(red: 22/255, green: 51/255, blue: 89/255, alpha: 1)
             }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.1, animations: {
            self.signUpButton.alpha = 0.7
            self.signUpButton.isUserInteractionEnabled = false
            self.signUpButton.backgroundColor = UIColor.lightGray
                }, completion: nil)
        }
    }
    
    func setUpEmailTextField(){
        if UserDefaults.standard.object(forKey: "login_email") != nil {
            emailTextField.text = UserDefaults.standard.object(forKey: "login_email") as? String
            passwordTextField.becomeFirstResponder()
        }else{
            emailTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func exitVC(_ sender: Any) {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        logIn()
    }
    
    func logIn(){
        dismissKeyboard()
        guard let email = emailTextField.text, !email.isEmpty else {
            self.displayAlert("Error", message:"Must enter a valid email")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.displayAlert("Error", message:"Must enter a valid password")
            return
        }
        
        startLoader(laodingMessage: "Logging In...")
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{ self.displayAlert("Error", message: (error?.localizedDescription)!)
                return
            }
            
            guard let currentUser = FIRAuth.auth()?.currentUser! else {return}
            
            if currentUser.isEmailVerified == true {
                self.performSegue(withIdentifier: "signedIn", sender: self)

            } else {
                self.runVerificationProcess()
            }
        })
    }
    
    func runVerificationProcess(){
        let alert = UIAlertController(title: "Verification Error", message: "This account has not been verified. Please verify your account with the link sent to your email and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in }))
        alert.addAction(UIAlertAction(title: "Resend Link", style: .default, handler: { (action) in
            self.sendEmailVerification()
        }))
        
        self.present(alert, animated: true, completion: {
            self.endLoader()
        })
    }
    
    @IBAction func forgotEmailButtonPressed(_ sender: Any) {
        forgotEmail()
    }
    
    func forgotEmail(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Forgot Password", message: "Please Enter the email associated with the account.", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            if let email = self.emailTextField.text {
                textField.text = email
            } else{
                textField.text = ""
            }
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send reset link", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            
            if let email = textField.text {
                self.startLoader(laodingMessage: "Sending Reset Link...")
                FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
                    if error != nil {
                        self.displayAlert("Error", message: (error?.localizedDescription)!)
                    }
                    self.displayAlert("Link Sent", message: "A password reset link has been sent to the provided email. Update your password with the link and log in again.")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendEmailVerification(){
        self.startLoader(laodingMessage: "Sending Verification Link...")
        
        FIRAuth.auth()?.currentUser?.sendEmailVerification { (error) in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                    self.endLoader()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            let alert = UIAlertController(title: "Link Sent", message: "A verification link has been sent to your email. Please verify your email and log back in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
//                self.endLoader()
            }))
            
            self.present(alert, animated: true, completion: {
                self.endLoader()
            })
        }
    }
    
    func startLoader(laodingMessage:String){
        self.verificationMessageLabel.text = laodingMessage
        self.verificationStackView.alpha = 1
        self.activityIndicator.startAnimating()
        self.mainStackView.alpha = 0
    }
    
    func endLoader(){
        self.verificationStackView.alpha = 0
        self.mainStackView.alpha = 1
        self.activityIndicator.stopAnimating()
    }
    
    func displayAlert(_ title: String, message: String){
        self.endLoader()
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in }))
        self.present(alert, animated: true, completion: {
//            self.endLoader()
        })
    }
}
