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
  
  @IBOutlet weak var cancelButton: UIButton!
  
  var firstNamePlaceHolderText: String = "Enter first name"
  var lastNamePlaceHolderText: String = "Enter last name"
  var phoneNumberPlaceHolderText: String = "Enter phone number"
  var emailPlaceHolderText: String = "Enter email address"
  var userNamePlaceHolderText: String = "Enter user name"
  var passwordPlaceHolderText: String = "Enter password"
  
  var user: User?
  var validInput: Bool?
  
  var gradientLayer: CAGradientLayer!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
      tap.cancelsTouchesInView = false
      self.view.addGestureRecognizer(tap)

      applyPlaceholderStyle(text: firstNameTextField, phText: firstNamePlaceHolderText)
      applyPlaceholderStyle(text: lastNameTextField, phText: lastNamePlaceHolderText)
      applyPlaceholderStyle(text: phoneNumberTextField, phText: phoneNumberPlaceHolderText)
      applyPlaceholderStyle(text: emailTextField, phText: emailPlaceHolderText)
      applyPlaceholderStyle(text: userNameTextField, phText: userNamePlaceHolderText)
      applyPlaceholderStyle(text: passwordTextField, phText: passwordPlaceHolderText)
      
      
      signUpButton.layer.cornerRadius = 4
      cancelButton.layer.cornerRadius = 4
      
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
    text.layer.borderWidth = 0
    text.alpha = 1.0
    validInput = true
  }
  
  func applyInvalidStyle(text: UITextField) {
    text.layer.borderWidth = 4
    text.layer.borderColor = UIColor(red:0.80, green:0.67, blue:0.81, alpha:1.0).cgColor // hex #CDACCE
  }
  
  func createGradientLayer() {
    
    gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [UIColor.purple.cgColor, UIColor.black.cgColor]
    
    self.view.viewWithTag(1)?.layer.addSublayer(gradientLayer)
      
  }
  
// MARK: - SIGN UP AND LOG IN
  
  @IBAction func onSignUp(_ sender: UIButton) {
   
    if validateForm() == true {

      setUser( completionHandler: {
        didSetUser -> Void in
        if didSetUser {
          print("User is: \(user!.userName!)")
          performUserLogin(user: user!)
        } else {
          print("Unexpected error encountered")
        }
      })
      
      
    }
  }
  
  
  func validateForm() -> Bool {
    
    if firstNameTextField.text == "" || firstNameTextField.text == firstNamePlaceHolderText {
      print("first name not valid")
      applyInvalidStyle(text: firstNameTextField)
      validInput = false
    }
    
    if lastNameTextField.text == "" || lastNameTextField.text == lastNamePlaceHolderText {
      print("last name not valid")
      applyInvalidStyle(text: lastNameTextField)
      validInput = false
    }
    
    if phoneNumberTextField.text == "" || phoneNumberTextField.text == phoneNumberPlaceHolderText {
      print("phone number not valid")
      applyInvalidStyle(text: phoneNumberTextField)
      validInput = false
    }
    
    if emailTextField.text == "" || emailTextField.text == emailPlaceHolderText {
      print("email not valid")
      applyInvalidStyle(text: emailTextField)
      validInput = false
    }
    
    if userNameTextField.text == "" || userNameTextField.text == userNamePlaceHolderText {
      print("username not valid")
      applyInvalidStyle(text: userNameTextField)
      validInput = false
    }
    
    if passwordTextField.text == "" || passwordTextField.text == passwordPlaceHolderText {
      print("password not valid")
      applyInvalidStyle(text: passwordTextField)
      validInput = false
    }
    
    if validInput == false {
      showAlert()
    } else {
      validInput = true
      print("Valid input")
    }
    
    return validInput!
  }
  
  func setUser( completionHandler: (Bool) -> Void) {
  
    user = User(username: userNameTextField.text!, psswd: passwordTextField.text!, emailaddress: emailTextField.text!, telNum: phoneNumberTextField.text!, fname: firstNameTextField.text!, lname: lastNameTextField.text!)
    
    completionHandler(true)
  }
  
  
  func performUserLogin(user: User) {

    PFUser.logInWithUsername(inBackground: (user.userName)!, password: (user.password)!) { (user: PFUser?, error: Error?) -> Void in
      
      if user != nil {
        User.currentUser = user
        print("successful sign-up")
        self.goToProfile(currUser: user!)
      }
    }
  }

  func goToProfile(currUser: PFUser) {
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidSignUp), object: nil)
  }
  
  
  
  @IBAction func onTap(_ sender: UITapGestureRecognizer)
  {
    self.view.endEditing(true)
  }
  
  
  @IBAction func onCancel(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  func showAlert() {
    
    let alertController = UIAlertController(title: "Incomplete Fields", message: nil, preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
    if segue.identifier == "ProfileSegue" {
      
      print("Preparing for segue")
    }
  }
  
  
}
