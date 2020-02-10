//
//  HomeViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/8/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var result: UILabel!

    @IBOutlet weak var signOutButton: UIButton!
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        Utilities.styleHollowButton(signOutButton)
        
        // listening for user logging in state change
        Auth.auth().addStateDidChangeListener { (auth, user) in
          if let user = user {
            //retrive user email
            //user is signed in
            let email = user.email
            self.result.text = email
            print("user is logged in")
          }
          else{
            // no user is signed in
          }
            
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - API
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            navigateToMainScreen()
            
        } catch let error {
            print("Failed to sign out with error..", error)
        }
    }
    
    
    @IBAction func singOutClicked(_ sender: Any) {
        handleSignOut()
    }
    
    
    // MARK: -Navigate to Main Screen
    func navigateToMainScreen(){
           //cast view to viewcontroller
           let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController) as? ViewController
           // set the root view to home view controller
           view.window?.rootViewController = homeViewController
           view.window?.makeKeyAndVisible()
           
    }
    
    
    
   

}

