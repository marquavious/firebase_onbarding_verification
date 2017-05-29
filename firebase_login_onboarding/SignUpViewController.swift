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

protocol CloseModelDelegate {
    func dismissControler()
    func stopLoaderFromDelegate()
}

class SignUpViewController: UIViewController, CloseModelDelegate {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var verificationStackView: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var verificationMessageLabel: UILabel!
    var delegate: LoginSegueDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotifications()
        hideKeyboardWhenTappedAround()
        signUpButton.addCornerRadius(4.5)
        signUpButton.alpha = 0.7
        signUpButton.backgroundColor = UIColor.lightGray
        signUpButton.isUserInteractionEnabled = false
        addSwipeDownFunction()
        fullNameTextField.becomeFirstResponder()
    }
    
    func setUpNotifications(){
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if emailTextField.hasText && passwordTextField.hasText && fullNameTextField.hasText {
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
    
    @IBAction func exitVC(_ sender: Any) {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    func stopLoaderFromDelegate() {
        endLoader()
    }
    
    func dismissControler() {
        self.dismiss(animated: true, completion: {
            self.delegate?.showLogin()
        })
    }
    
    func displayAlert(_ title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in }))
        self.present(alert, animated: true, completion: {
            self.endLoader()
        })
    }
    
    func signUp(){
        dismissKeyboard()
        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            self.displayAlert("Error", message:"Please enter your name")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            self.displayAlert("Error", message:"Please enter your email")
            return
        }
        startLoader(laodingMessage: "Creating Account...")
        FIRAuth.auth()?.createUser(withEmail: email, password: passwordTextField.text!, completion: { (user, error) in
            
            if error != nil{
                self.displayAlert("Error", message: error!.localizedDescription)
                return
            }
            
            self.startLoader(laodingMessage: "Sending Verification Email...")
            self.sendEmailVerification()
            UserDefaults.standard.set(email, forKey: "login_email")
            UserDefaults.standard.synchronize()
        })
    }
    
    func sendEmailVerification(){
        FIRAuth.auth()?.currentUser?.sendEmailVerification { (error) in
            if error != nil{
                self.displayAlert("Error", message: error!.localizedDescription)
            }
            self.performSegue(withIdentifier: "emailVerified", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "emailVerified"{
            let destination = segue.destination as! SucessViewController
            destination.delegate = self
        }
    }
    
    func startLoader(laodingMessage:String){
        verificationMessageLabel.text = laodingMessage
        verificationStackView.alpha = 1
        activityIndicator.startAnimating()
        mainStackView.alpha = 0
    }
    
    func endLoader(){
        verificationStackView.alpha = 0
        activityIndicator.stopAnimating()
        mainStackView.alpha = 1
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        signUp()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addSwipeDownFunction(){
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func swipedDown(){
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIButton {
    func addCornerRadius(_ amount: CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = amount
    }
}
