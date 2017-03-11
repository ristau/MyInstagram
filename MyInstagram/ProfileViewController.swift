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
  @IBOutlet weak var saveButton: UIButton!
  
  var post: PFObject!
  var fullName: String!
  var image: UIImage!
  var changedProfileImage: Bool?
  
    override func viewDidLoad() {
        super.viewDidLoad()

      
      changedProfileImage = false
      self.navigationItem.title = "Profile"
      self.logoutButton.layer.cornerRadius = 4
      self.saveButton.layer.cornerRadius = 4
      
     // profileImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
     // profileImageView.layer.borderWidth = 1;
  
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
   
    User.currentUser = PFUser.current()
    getCurrentUserName()
    
    if !changedProfileImage! {
      getCurrentUserImage()
    }
    
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    changedProfileImage = false
  }
  
  
  func getCurrentUserName() {
    
    let _firstname = User.currentUser!["firstname"]
    let _lastname = User.currentUser!.object(forKey: "lastname")
    
    // convert first and last name to full name
    let charSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
    let unformattedFirstName = String(describing: _firstname!)
    let firstName = unformattedFirstName.components(separatedBy: charSet).joined(separator: "")
    let unformattedLastName = String(describing: _lastname!)
    let lastName = unformattedLastName.components(separatedBy: charSet).joined(separator: "")
    
    fullName = firstName + " " + lastName
    
    welcomeNameLabel.text = ("Welcome, \(fullName!)")

  }
  
  // MARK: - SHOW IMAGE
  
  func show(image: UIImage) {
    
    profileImageView.image = image
    profileImageView.frame = CGRect(x: 70, y: 50, width: 64, height: 64)
    // adjust x and y coordinates, can these be set in autolayout

  }
  
  @IBAction func saveProfileImage(_ sender: UIButton) {
    postProfileImageToParse()
  }
  
  
  func postProfileImageToParse() {
  
    User.saveProfileImage(image: profileImageView.image) { (success: Bool, error: Error?) -> Void in
      
      if success {
        print("Successful Post to Parse")
        
        let hudView = HudView.hud(inView: self.navigationController!.view, animated: true)
        hudView.text = "Saved!"
        
        afterDelay(0.6) {
          hudView.isHidden = true
          hudView.removeFromSuperview()
          self.tabBarController?.selectedIndex = 0
        }
      }
      else {
        print("Can't post to parse")
      }
    }
  }


  func getCurrentUserImage() {

    let myImage = PFImageView()
    
    if User.currentUser?["profile_image"] != nil {
      myImage.file = User.currentUser?["profile_image"] as? PFFile
      myImage.loadInBackground()
    } else {
      myImage.image = UIImage(named: "placeholderBlue64")!
    }
    
    
    profileImageView.image = myImage.image
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = 15
      
  }


  @IBAction func onCameraTap(_ sender: UIButton) {
    print("Tapped on camera")
    pickPhoto()
  }
  
  @IBAction func onLogout(_ sender: UIButton) {
    print("Logging Out.  Goodbye.")

    let hudView = HudView.hud(inView: self.navigationController!.view, animated: true)
    hudView.text = "Goodbye!"
    
    afterDelay(1.0) {
      hudView.isHidden = true
      hudView.removeFromSuperview()
      User.logout()
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


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func takePhotoWithCamera() {
    
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    image = info[UIImagePickerControllerEditedImage] as? UIImage
    print("did pick the image")
    
    if let theImage = image{
      print("Going to show the image")
      changedProfileImage = true
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
