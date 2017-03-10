//
//  LoginViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/13/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import Parse 

class LoginViewController: UIViewController {

  
  @IBOutlet weak var loginButton: UIButton!
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  var gradientLayer: CAGradientLayer!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    loginButton.layer.cornerRadius = 4
    
    createGradientLayer()
    addTapGesture()
    
    
  }

  
  func createGradientLayer() {
    gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [UIColor.blue.cgColor, UIColor.black.cgColor]
    
    self.view.viewWithTag(1)?.layer.addSublayer(gradientLayer)
  }
  
  func addTapGesture() {
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
  }
  
  
  @IBAction func onSignIn(_ sender: Any) {
    PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) -> Void in
      
      if user != nil {
      print("You're logged in!")
      self.performSegue(withIdentifier: "LoginSegue", sender: nil)
      }
      if error != nil {
        print("problem logging in")
        self.showAlert()
      }
    }
  }
  

  
  @IBAction func onSignUp(_ sender: Any) {
    
    print("Going to Sign Up View Controller")
 
  }
  
  
  func showAlert() {
    let alertController = UIAlertController(title: "Incorrect Username or Password", message: nil, preferredStyle: .actionSheet)
    
    let forgotUserNameOrPasswordAction = UIAlertAction(title: "Forgot Password?", style: .default, handler: {_ in self.resetPassword() })
    alertController.addAction(forgotUserNameOrPasswordAction)
    
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
    
  }

  
  
  func resetPassword() {
   
    let resetPasswordController = UIAlertController(title: "Reset Password", message: nil, preferredStyle: .alert)
    
    let resetAction = UIAlertAction(title: "Submit", style: .default, handler: { alert -> Void in
      let emailTextField = resetPasswordController.textFields![0] as UITextField
      self.displayMessage()
    })
    
   let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

   resetPasswordController.addTextField { (textField : UITextField!) -> Void in
      textField.placeholder = "Enter Email"
    }

    resetPasswordController.addAction(resetAction)
    resetPasswordController.addAction(cancelAction)
    
    self.present(resetPasswordController, animated: true, completion: nil)
   
  }
  
  func displayMessage() {
    let messageController = UIAlertController(title: "Reset link sent to your email", message: nil, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    messageController.addAction(cancelAction)
    self.present(messageController, animated: true, completion: nil)
  }
  
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
