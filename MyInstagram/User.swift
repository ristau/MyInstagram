//
//  User.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import Foundation
import Parse

class User: NSObject {
  
  var firstName: String?
  var lastName: String?
  var userName: String?
  var password: String?
  var telNumber: String?
  var email: String?
  var user: PFUser?
  
  var dictionary: NSDictionary?
  
  init(dictionary: NSDictionary) {
    
    self.dictionary = dictionary
    
    firstName = dictionary["firstname"] as? String
    lastName = dictionary["lastname"] as? String
    userName = dictionary["username"] as? String
    password = dictionary["password"] as? String
    telNumber = dictionary["telnumber"] as? String
    email = dictionary["email"] as? String
    
  }
  

  init(username: String, psswd: String, emailaddress: String, telNum: String, fname: String, lname: String) {
    
    userName = username
    password = psswd
    email = emailaddress
    firstName = fname
    lastName = lname
    telNumber = telNum
  
    user = PFUser()
    
    user?.username = userName
    user?.password = password
    user?.email = email
    user?.add(firstName! as Any, forKey: "firstname")
    user?.add(lastName! as Any, forKey: "lastname")
    user?.add(telNumber! as Any, forKey: "telnumber")
    
    user?.signUpInBackground{ (success: Bool, error: Error?) -> Void in
      
      if success {
        print ("Successfully created a new user")
      } else {
        print("Error: \(error!.localizedDescription)")
      }
    }
  }
  
  
  func loginWithParseUser(username: String, password: String) {
    
    
    
  }
  
  // setting up current pfuser
  
  static let userDidLogoutNotification = "UserDidLogout"
  static var _currentUser: User?
  
}

