//
//  ProfileViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import Parse


class ProfileViewController: UIViewController {

  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var welcomeNameLabel: UILabel!
  @IBOutlet weak var profileImageView: UIImageView!

  var post: PFObject!
  var user: PFUser!
  var fullName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

      self.navigationItem.title = "Profile"
      self.logoutButton.layer.cornerRadius = 4
      
      let myImage = UIImage(named: "placeholderBlue64")
      profileImageView.image = myImage
      profileImageView.clipsToBounds = true
      profileImageView.layer.cornerRadius = 15
     // profileImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
     // profileImageView.layer.borderWidth = 1;
      
      getCurrentUserName()
      getCurrentUserImage()

    }

  
  func getCurrentUserName() {
    
    user = PFUser.current()
    let _firstname = user!["firstname"]
    let _lastname = user!.object(forKey: "lastname")
    
    // convert first and last name to full name
    let charSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
    let unformattedFirstName = String(describing: _firstname!)
    let firstName = unformattedFirstName.components(separatedBy: charSet).joined(separator: "")
    let unformattedLastName = String(describing: _lastname!)
    let lastName = unformattedLastName.components(separatedBy: charSet).joined(separator: "")
    
    fullName = firstName + " " + lastName
    
    welcomeNameLabel.text = ("Welcome, \(fullName!)")
    
    // getting the profile image 
    //"bfrfeb17_120x160"

  }
  
  func getCurrentUserImage() {


    
    
  }

  

  @IBAction func onCameraTap(_ sender: UIButton) {
    print("Tapped on camera")
  }
  
  @IBAction func onLogout(_ sender: UIButton) {
    print("Logging Out.  Goodbye.")
    
    PFUser.logOutInBackground(block: { (error: Error?) -> Void in
      if error != nil {
        print("Problem logging out")
      } else {
        self.dismiss(animated: true, completion: nil)
      }
    })
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
