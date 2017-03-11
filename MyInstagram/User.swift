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
  
  static let userDidLogoutNotification = "UserDidLogout"
  static let userDidSignUp = "UserDidSignUp"
  static let userDidLogIn = "UserDidLogIn"
  
  static var currentUser: PFUser?
  
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
        User.currentUser = PFUser.current()
      } else {
        print("Error: \(error!.localizedDescription)")
      }
    }
  }
  
  
  class func saveProfileImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {

    //let user = PFUser.current()
    
    // Add relevant fields to the object
    User.currentUser?["profile_image"] = getPFFileFromImage(image: image) // PFFile column type
    
    // Save object (following function will save the object in Parse asynchronously)
    User.currentUser?.saveInBackground(block: completion)
  }
  
  
  class func getPFFileFromImage(image: UIImage?) -> PFFile? {
    // check if image is not nil
    if let image = image {
      // get image data and check if that is not nil
      if let imageData = UIImagePNGRepresentation(image) {
        return PFFile(name: "image.png", data: imageData)
      }
    }
    return nil
  }
  
  class func logout() {
    
    User.currentUser = nil
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    
    PFUser.logOutInBackground(block: { (error: Error?) -> Void in
      if error != nil {
        print("Problem logging out")
      } else {
        print("User logged out")
      }
    })
  }
}





