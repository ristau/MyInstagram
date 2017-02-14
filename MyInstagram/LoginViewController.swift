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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func onSignIn(_ sender: Any) {
    PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) -> Void in
      
      if user != nil {
      print("You're logged in!")
      self.performSegue(withIdentifier: "loginSegue", sender: nil)
      }
    }
  }
  
  
  @IBAction func onSignUp(_ sender: Any) {
    
    let newUser = PFUser()
    newUser.username = usernameField.text
    newUser.password = passwordField.text
    
    newUser.signUpInBackground{ (success: Bool, error: Error?) -> Void in
    
      if success {
        print("Yay, created a user")
      } else {
        print("Error: \(error?.localizedDescription)")
       // if error.code == 202 {
         // print("User name is taken")  // parse error codes not showing
      }
      
    }
    
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
