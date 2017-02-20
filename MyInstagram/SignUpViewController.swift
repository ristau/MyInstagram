//
//  SignUpViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import Parse
import Dispatch

class SignUpViewController: UIViewController, UITextFieldDelegate {
  
  
  @IBOutlet weak var signUpButton: UIButton!
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var firstNamePlaceHolderText: String = "Enter first name"
  var lastNamePlaceHolderText: String = "Enter last name"
  var phoneNumberPlaceHolderText: String = "Enter phone number"
  var emailPlaceHolderText: String = "Enter email address"
  var userNamePlaceHolderText: String = "Enter user name"
  var passwordPlaceHolderText: String = "Enter password"
  
  var user: User?
  var firstName: String?
  var lastName: String?
  var phoneNumber: String?
  var email: String?
  var userName: String?
  var password: String?
  
  var gradientLayer: CAGradientLayer!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      applyPlaceholderStyle(text: firstNameTextField, phText: firstNamePlaceHolderText)
      applyPlaceholderStyle(text: lastNameTextField, phText: lastNamePlaceHolderText)
      applyPlaceholderStyle(text: phoneNumberTextField, phText: phoneNumberPlaceHolderText)
      applyPlaceholderStyle(text: emailTextField, phText: emailPlaceHolderText)
      applyPlaceholderStyle(text: userNameTextField, phText: userNamePlaceHolderText)
      applyPlaceholderStyle(text: passwordTextField, phText: passwordPlaceHolderText)
      
      
      signUpButton.layer.cornerRadius = 4
      
      firstNameTextField?.delegate = self
      lastNameTextField?.delegate = self
      phoneNumberTextField?.delegate = self
      emailTextField?.delegate = self
      userNameTextField?.delegate = self
      passwordTextField?.delegate = self
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    createGradientLayer()
  }
  
  // MARK: - TEXTFIELD METHODS
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    moveCursorToStart(text: textField)
    
    return true
  }
  
  func moveCursorToStart(text: UITextField)
  {
    DispatchQueue.main.async {
      
      let newPosition = text.beginningOfDocument
      text.selectedTextRange = text.textRange(from: newPosition, to: newPosition)
      
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString text: String) -> Bool {
    
    let newLength = (textField.text?.utf16.count)! + text.utf16.count - range.length
    if newLength > 0 // have text, so don't show the placeholder
    {
      applyNonPlaceholderStyle(text: textField)
    }
    return true
    
  }
  
  
  // MARK: - STYLING METHODS
  
  func applyPlaceholderStyle(text: UITextField, phText: String) {
    text.textColor = UIColor.lightGray
    text.text = phText
  }
  
  func applyNonPlaceholderStyle(text: UITextField) {
    text.textColor = UIColor.darkText
    text.alpha = 1.0
  }
  
  func createGradientLayer() {
    
    gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [UIColor.purple.cgColor, UIColor.black.cgColor]
    
    self.view.viewWithTag(1)?.layer.addSublayer(gradientLayer)
      
  }
  
// MARK: - Completing Sign Up and Leaving View Controller
  
  @IBAction func onSignUp(_ sender: UIButton) {
    print("Signing Up the new user")
    
//    let hudView = hudView.hud(inView: viewWithTag(1), animated: true)
    let hudView = HudView.hud(inView: navigationController!.view, animated: true)
    hudView.text = "Welcome!"

    
    firstName = firstNameTextField.text
    lastName = lastNameTextField.text
    phoneNumber = phoneNumberTextField.text
    email = emailTextField.text
    userName = userNameTextField.text
    password = passwordTextField.text
    
    user = User(username: userName!, psswd: password!, emailaddress: email!, telNum: phoneNumber!, fname: firstName!, lname: lastName!)
 
    afterDelay(0.6) {
      hudView.isHidden = true
      self.performUserLogin()
    }

  }
  
  @IBAction func onTap(_ sender: UITapGestureRecognizer)
  {
    self.view.endEditing(true)
  }
  
  
  @IBAction func onCancel(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  
  func performUserLogin() {
    
    PFUser.logInWithUsername(inBackground: (user?.userName)!, password: (user?.password)!) { (user: PFUser?, error: Error?) -> Void in
      
      if user != nil {
        print("You're logged in!")
        self.performSegue(withIdentifier: "GoToProfile", sender: nil)
      }
    }
  }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
     // if segue.identifier == "loginSegue"
     // {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
     // }

}
