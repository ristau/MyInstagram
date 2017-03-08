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
    
  }

  
  func createGradientLayer() {
    
    gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [UIColor.blue.cgColor, UIColor.black.cgColor]
    
    self.view.viewWithTag(1)?.layer.addSublayer(gradientLayer)
    
  }
  
  
  @IBAction func onSignIn(_ sender: Any) {
    PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) -> Void in
      
      if user != nil {
      print("You're logged in!")
      self.performSegue(withIdentifier: "LoginSegue", sender: nil)
      }
      else {
        self.showAlert()
      }
    }
  }
  

  
  @IBAction func onSignUp(_ sender: Any) {
    
    print("Going to Sign Up View Controller")
 
  }
  
  
  func showAlert() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    let problemWithLoginAction = UIAlertAction(title: "Incorrect Username or Password", style: .cancel, handler: nil)
    alertController.addAction(problemWithLoginAction)
    
    present(alertController, animated: true, completion: nil)
    
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
