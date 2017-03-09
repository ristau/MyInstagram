//
//  ProfileViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import Parse
import ParseUI


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
      user = PFUser.current()
      
      //let myImage = UIImage(named: "placeholderBlue64")
      let myImage = PFImageView()
      
      if user?["profile_image"] != nil {
        myImage.file = user?["profile_image"] as? PFFile
        myImage.loadInBackground()
      } else {
        myImage.image = UIImage(named: "placeholderBlue64")!
      }
      
      
      profileImageView.image = myImage.image
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
  
  // MARK: - SHOW IMAGE
  
  func show(image: UIImage) {
    
    profileImageView.image = image
    //captureImageView.isHidden = false
    profileImageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
    
  }
  
  @IBAction func saveProfileImage(_ sender: UIButton) {
    postProfileImageToParse()
  }
  
  
  func postProfileImageToParse() {
  
    User.saveProfileImage(image: profileImageView.image) { (success: Bool, error: Error?) -> Void in
      
      if success {
        print("Successful Post to Parse")
      }
      else {
        print("Can't post to parse")
      }
    }
  }


  func getCurrentUserImage() {


    
    
  }



  @IBAction func onCameraTap(_ sender: UIButton) {
    print("Tapped on camera")
    pickPhoto()
  }
  
  @IBAction func onLogout(_ sender: UIButton) {
    print("Logging Out.  Goodbye.")
    
    PFUser.logOutInBackground(block: { (error: Error?) -> Void in
      if error != nil {
        print("Problem logging out")
      } else {
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController        
        self.present(loginVC, animated: true, completion: nil)

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


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func takePhotoWithCamera() {
    
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    let image = info[UIImagePickerControllerEditedImage] as? UIImage
    
    if let theImage = image{
      show(image: theImage)
    }
    
    //tableView.reloadData()
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
    dismiss(animated: true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func pickPhoto() {
    if true || UIImagePickerController.isSourceTypeAvailable(.camera) {
      showPhotoMenu()
    }
    else {
      choosePhotoFromLibrary()
    }
  }
  
  func showPhotoMenu() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {_ in self.takePhotoWithCamera() })
    alertController.addAction(takePhotoAction)
    
    let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .default, handler: {_ in self.choosePhotoFromLibrary() })
    
    alertController.addAction(chooseFromLibraryAction)
    present(alertController, animated: true, completion: nil)
  }
  
}
