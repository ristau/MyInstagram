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

  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
  }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func onSignIn(_ sender: Any) {
    PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) -> Void in
      
      if user != nil {
      print("You're logged in!")
      self.performSegue(withIdentifier: "LoginSegue", sender: nil)
      }
    }
  }
  
  
  @IBAction func onSignUp(_ sender: Any) {
    
    print("Going to Sign Up View Controller")
 
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
