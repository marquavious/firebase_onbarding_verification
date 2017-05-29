//
//  SucessViewController.swift
//  firebase_login_onboarding
//
//  Created by Marquavious on 5/27/17.
//  Copyright © 2017 Marquavious Draggon. All rights reserved.
//

import UIKit

class SucessViewController: UIViewController {

    var delegate: CloseModelDelegate?
    
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.addCornerRadius(4.5)
        addSwipeDownFunction()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.stopLoaderFromDelegate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            // add code here
            self.delegate?.dismissControler()
        }
    }
}
