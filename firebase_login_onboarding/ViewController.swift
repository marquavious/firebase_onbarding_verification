//
//  ViewController.swift
//  firebase_login_onboarding
//
//  Created by Marquavious on 5/26/17.
//  Copyright © 2017 Marquavious Draggon. All rights reserved.
//

import UIKit
//loginButtonPressed

protocol LoginSegueDelegate {
    func showLogin()
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, LoginSegueDelegate {
    
    func showLogin() {
        performSegue(withIdentifier: "loginButtonPressed", sender: self)
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var signUpButton: UIButton!
    let nib = UINib(nibName: "OnboardingCollectionViewCell", bundle: nil)
    
    var descriptions = ["Welcome To Connect&Care: Your innovative solution to  help make the world a better place!","Connect&Care allows you donate seamlessly to over 20+ verified non profits worldwide.","Your donations will go toward global projects like, clean water, health care, community building, education and more!","Connect&Care utilizes Apple Pay to ensure your donations reaches its destination in the fastest, most secure way possible. ","Sign up to try the future of philanthropy! "]
    var images:[UIImage] = [#imageLiteral(resourceName: "world_full"),#imageLiteral(resourceName: "hand_heart"),#imageLiteral(resourceName: "world_in_hand")]
    var titles = ["Welcome!", "Multiple Non Profits","Support Global Projects"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFunctions()
        collectionView.delegate = self
        collectionView.dataSource = self
        signUpButton.addCornerRadius(4)
        loginButton.addCornerRadius(4)
    }
    
    func setUpFunctions(){
        collectionView.register(nib, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        pageIndicator.numberOfPages = 3 // Hard coded for now
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func checkToSeeIfUserIsAtTheEndOfOnboarding(input:Int, target: Int) ->Bool {
        return input == target
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let page = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        pageIndicator.currentPage = page
        
        if checkToSeeIfUserIsAtTheEndOfOnboarding(input: page, target: 2){
            performSegue(withIdentifier: "signUp", sender: self)
        } else{
            // If its not at the end, move to the next page
            collectionView.setContentOffset(CGPoint(x:  CGFloat(page+1) * collectionView.bounds.size.width , y: 0), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageIndicator.currentPage = page
        
        if checkToSeeIfUserIsAtTheEndOfOnboarding(input: page, target: 2){
            signUpButton.setTitle("Sign Up", for: .normal)
        } else{
            signUpButton.setTitle("Next", for: .normal)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let page = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
        pageIndicator.currentPage = page
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        print(indexPath)
        print(descriptions[page])
        cell.onboardingDescription.text = descriptions[page]
        cell.onbardingTitle.text = titles[page]
        cell.imageView.image = images[page]
        
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3 // Hard coded for now
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp"{
            let destination = segue.destination as! SignUpViewController
            destination.delegate = self
        }
    }
}


