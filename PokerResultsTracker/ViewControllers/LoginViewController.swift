//
//  LoginViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/8/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLable: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initElements()
        
        //adding swipe listener
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
    
    }
    
    func initElements(){
        //trasnparent error lable
        errorLable.alpha = 0
        
        //style components
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: -Login User
    fileprivate func loginUser(_ email: String, _ password: String) {
        //signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil{
                // error signing in user
                self.errorLable.alpha = 1
                self.errorLable.text = err!.localizedDescription
            }
            else{
                
                //cast view to homeviewcontroller
//                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController)
//                // set the root view to home view controller
//                self.view.window?.rootViewController = homeViewController
//                self.view.window?.makeKeyAndVisible()
                
                let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeTabViewController) as! MainTabController
                
                // TODO: Fix this
                // Select Tab
                mainTabController.selectedViewController = mainTabController.viewControllers?[1]// 0 indexed
            
                self.view.window?.rootViewController = mainTabController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        //get user input password and email
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        loginUser(email, password)
    }
}
