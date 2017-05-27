//
//  SignUpViewController.swift
//  firebase_login_onboarding
//
//  Created by Marquavious on 5/27/17.
//  Copyright © 2017 Marquavious Draggon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var verificationStackView: UIStackView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         checkForVerification()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForVerification), userInfo: nil, repeats: true)
        self.sendEmailVerification()

//                logOut()
        //        waitForVerification {
        //            FIRAuth.auth()?.currentUser?.sendEmailVerification { (error) in
        //                if error != nil{
        //                    self.displayAlert("Error", message: error!.localizedDescription)
        //                }
        //
        //                self.startLoader()
        //
        //                FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
        //                    // ...
        //                    print("IT HAS BEEN VERIFIED")
        //                }
        //            }
        //        }
        //        logIn(email: "marq.draggon@gmail.com", password: "123456")
    }
    
    func logIn(email:String, password:String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            print("Logged in")
            
        })
    }
    
    @IBAction func exitVC(_ sender: Any) {
        
    }
    
    func displayAlert(_ title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func signUp(){
        
        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            self.displayAlert("Error", message:"Please enter your name")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            self.displayAlert("Error", message:"Please enter your email")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil{
                self.displayAlert("Error", message: error!.localizedDescription)
            }
            self.sendEmailVerification()
            self.waitForVerification()
        })
        
    }
    
    func sendEmailVerification(){
        startLoader()
        FIRAuth.auth()?.currentUser?.sendEmailVerification { (error) in
            if error != nil{
                self.displayAlert("Error", message: error!.localizedDescription)
            }
        }
    }
    
    func waitForVerification(){
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForVerification), userInfo: nil, repeats: true)
    }
    

    
    func checkForVerification(){
//        FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
            // ...
//            print("IT HAS BEEN VERIFIED")
            
            
            
            if (FIRAuth.auth()?.currentUser!.isEmailVerified)!{
                print("VERIFIED")
            }else{
                print("waiting...")
            }
//        }
    }
    
    func startLoader(){
        verificationStackView.alpha = 1
        activityIndicator.startAnimating()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        signUp()
    }
    
    func logOut(){
        try! FIRAuth.auth()!.signOut()
        FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            if user != nil {
            } else {
                
            }
        })
    }
    
    //    firebase.auth().onAuthStateChanged(function(user) {
    //    if (user.emailVerified) {
    //    console.log('Email is verified');
    //    }
    //    else {
    //    console.log('Email is not verified');
    //    }
    //    });
    
    //    firebase.auth().onAuthStateChanged(function(user) {
    //    user.sendEmailVerification();
    //    });
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}