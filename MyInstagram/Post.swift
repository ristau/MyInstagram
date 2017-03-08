//
//  Post.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class Post: NSObject {
  
  var photoDescription: String?
  var photoImage: UIImage?
  var dateString: String?
  
  init(photoCaption: String, capturedImage: UIImage, currDateString: String){
  
    photoDescription = photoCaption
    photoImage = capturedImage
    dateString = currDateString
    
  }
  
  
  
    // properties
  // constructors
  // other methods  
  
  class func createNewPost(post: Post, withCompletion completion: PFBooleanResultBlock?) {
    
    let Post = PFObject(className: "Post")
    Post["photo"] = getPFFileFromImage(image: post.photoImage)
    Post["caption"] = post.photoDescription
    Post["date"] = post.dateString
    
    // get author name from current PFUser
   // let currentUser = PFUser.current()
    let user = PFUser.current()
    let _firstname = user!["firstname"]
    let _lastname = user!.object(forKey: "lastname")
  
    // convert first and last name to full name 
    let charSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
    let unformattedFirstName = String(describing: _firstname!)
    let firstName = unformattedFirstName.components(separatedBy: charSet).joined(separator: "")
    let unformattedLastName = String(describing: _lastname!)
    let lastName = unformattedLastName.components(separatedBy: charSet).joined(separator: "")
    
    let authorName = firstName + " " + lastName
    Post["fullname"] = authorName
    
    Post.saveInBackground(block: completion)
    
  }
  
  
  
  class func postUserImage(image: UIImage?, withDescription description: String?, withCompletion completion: PFBooleanResultBlock?) {
    // Create Parse object PFObject
    let post = PFObject(className: "Post")
    
    // Add relevant fields to the object
    post["photo"] = getPFFileFromImage(image: image) // PFFile column type
    post["author"] = PFUser.current() // Pointer column type that points to PFUser
    post["caption"] = description
    post["likesCount"] = 0
    post["commentsCount"] = 0
    
    // Save object (following function will save the object in Parse asynchronously)
    post.saveInBackground(block: completion)
  }

  /**
   Method to convert UIImage to PFFile
   
   - parameter image: Image that the user wants to upload to parse
   
   - returns: PFFile for the the data in the image
   */
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

  
}
