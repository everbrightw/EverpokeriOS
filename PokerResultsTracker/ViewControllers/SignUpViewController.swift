//
//  SignUpViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/8/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTExtField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var error: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Dissmiss keyboard when tap outside or User press return
        self.setupToHideKeyboardOnTapOnView()
        firstNameTextField.delegate = self
        lastNameTExtField.delegate = self
        emailTextField.delegate = self
        passWordTextField.delegate = self
        
        // styling elements
        styleElements()
        
        //adding swipe listener
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    // MARK: -dissmiss a keyboard when user finish editing(press return)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: - Customizing elements
    func styleElements(){
        
        // hide error label
        error.alpha = 0
        // setting up placeholder color
        firstNameTextField.attributedPlaceholder = NSAttributedString(string:"First Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lastNameTExtField.attributedPlaceholder = NSAttributedString(string:"Last Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passWordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        //customize login button
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /**
            Check fields to see if the data is correct. nil if it pass validation; error message otherwise
                
     */
    func validateFields()-> String? {
        //checking if all fields are filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTExtField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passWordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Some fields are not filled"
        }
        
        
        return nil
    }
    
    fileprivate func showErrorMessage(_ errorMessage: String?) {
        //field are not validate
        error.text = errorMessage
        //show error message
        error.alpha = 1
    }
    
    func navigateToMainScreen(){
        //cast view to viewcontroller
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController) as? ViewController
        // set the root view to home view controller
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    // MARK: - button onclick listener
    @IBAction func signUpTapped(_ sender: Any) {
        //valide fields
        let errorMessage = validateFields()
        
        if errorMessage != nil{
            showErrorMessage(errorMessage)
        }
        else{
            // get value from text fields
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTExtField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passWordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // check for err
                if err != nil {
                    //err showed
                    self.showErrorMessage("Creating user failed")
                }
                else{
                    //user was created
                    let db = Firestore.firestore()
                    // add a new document with a generated ID
                    db.collection("users").addDocument(data: ["first_name":firstName, "last_name":lastName, "uid":result!.user.uid]) { (err) in
                        
                        if err != nil {
                            // there is an error
                            self.showErrorMessage("User data could not be added to database")
                        }
                    }
                    
                }
            }
            // transition to home screen
            self.navigateToMainScreen()
            
        }
        
    }
    

}
