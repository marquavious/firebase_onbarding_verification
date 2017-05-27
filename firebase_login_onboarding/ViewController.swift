//
//  ViewController.swift
//  firebase_login_onboarding
//
//  Created by Marquavious on 5/26/17.
//  Copyright © 2017 Marquavious Draggon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var signUpButton: UIButton!
    let nib = UINib(nibName: "OnboardingCollectionViewCell", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(nib, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        pageIndicator.numberOfPages = 3
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func checkToSeeIfUserIsAtTheEndOfOnboarding(input:Int, target: Int) ->Bool {
        if input == target {
            return true
        }else{
            return false
        }
        
    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let page = collectionView.contentOffset.x / collectionView.frame.size.width
        pageIndicator.currentPage = Int(page)
        
        if checkToSeeIfUserIsAtTheEndOfOnboarding(input: Int(page), target: 2){
            signUp()
        } else{

            collectionView.setContentOffset(CGPoint(x:  CGFloat(page+1) * collectionView.bounds.size.width , y: 0), animated: true)
        }
    }
    
    func signUp(){
        performSegue(withIdentifier: "signUp", sender: self)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        pageIndicator.currentPage = Int(page)
        if checkToSeeIfUserIsAtTheEndOfOnboarding(input: Int(page), target: 2){
            signUpButton.setTitle("Sign Up", for: .normal)
        } else{
            signUpButton.setTitle("Next", for: .normal)
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let page = scrollView.contentOffset.x / scrollView.frame.size.width
//        pageIndicator.currentPage = Int(page)
//        if checkToSeeIfUserIsAtTheEndOfOnboarding(input: Int(page), target: 2){
//            signUpButton.setTitle("Sign Up", for: .normal)
//        } else{
//            signUpButton.setTitle("Next", for: .normal)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

