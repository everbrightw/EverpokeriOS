//
//  ViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/8/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    let backgroundImageView = UIImageView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dissmiss keyboard when tap view or user press a return
        self.setupToHideKeyboardOnTapOnView()
        emailTextField.delegate = self
        passwordTextField.delegate = self
            
        errorLabel.alpha = 0
        setBackground()
        // listening for user logging in state change
        Auth.auth().addStateDidChangeListener { (auth, user) in
          if let user = user {
            //user is signed in
            print("user is logged in")
          }
          else{
            // no user is signed in
            print("no user is logged in")
          }
            
        }
        
        // setting icon
        emailTextField.setLeftImage(imageName: "email-icon")
        passwordTextField.setLeftImage(imageName: "password-icon")
        // setting up placeholder color
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        //customize login button
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        // 118 217 171
        loginButton.addShadow(color: UIColor(red: 118/255, green:217/255, blue: 171/255, alpha:1).cgColor)
        
        // auto shrink for sign up button
        signupButton.titleLabel?.minimumScaleFactor = 0.5
        signupButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // style title
        let myMutableString = NSMutableAttributedString(string: "EVERPOKER", attributes: [NSAttributedString.Key.font :UIFont(name: "Avenir Black", size: 48.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:108/255, green:177/255, blue:147/255, alpha:1), range: NSRange(location:1,length:1))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:108/255, green:177/255, blue:147/255, alpha:1), range: NSRange(location:5,length:1))
        titleLabel.attributedText = myMutableString
    }
    
    // MARK: -Dissmiss a keyboard when user finish editing(press return)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    // MARK: -Set login page image background
    func setBackground(){
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.image = UIImage(named:"poker-background")
        backgroundImageView.alpha = 0.1
        
    }

    // sign up onclick method
    @IBAction func signupTapped(_ sender: Any) {
        print("sign up tapped")
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        loginUser(email, password)
    }
    
    // MARK: -Login User
    fileprivate func loginUser(_ email: String, _ password: String) {
        //signing in the user
        let errorMessage = validateFields()
        
        if errorMessage != nil{
            showErrorMessage(errorMessage)
        }
        else{
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    // error signing in user
                    self.showErrorMessage(err!.localizedDescription)
                }
                else{
                    let mainTabController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeTabViewController) as! MainTabController
                    
                    // TODO: Fix this
                    // Select Tab
                    mainTabController.selectedViewController = mainTabController.viewControllers?[1]// 0 indexed
                
                    self.view.window?.rootViewController = mainTabController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
    }
    
    // MARK: -Check if user had filled all fields
    func validateFields()-> String? {
        //checking if all fields are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            print("some fields are not filled")
            return "Some fields are not filled"
        }
        return nil
    }
    
    fileprivate func showErrorMessage(_ errorMessage: String?) {
        //field are not validate
        errorLabel.text = errorMessage
        //show error message
        errorLabel.alpha = 1
    }
}

extension UIViewController{
    @objc func swipeAction(swipe:UISwipeGestureRecognizer){
        switch swipe.direction.rawValue {
        case 1:
            // swipe left, goback
            performSegue(withIdentifier: "swipeLeft", sender: self)
        default:
            break
        }
    }
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}


extension UITextField{
    // MARK: -Add icon indicator on left of text field
    func setLeftImage(imageName:String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: imageName)
        imageView.tintColor = UIColor.white
        self.leftView = imageView;
        self.leftViewMode = .always
    }
}

extension UIButton {
    func addShadow(color: CGColor) {
        layer.shadowColor = color
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 1.0
       
    }
}
