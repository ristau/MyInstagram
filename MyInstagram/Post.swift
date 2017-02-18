//
//  Post.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import Foundation
import Parse

class Post: NSObject {
  
    
  
  
  
    // properties
  // constructors
  // other methods  
  
  class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
    // Create Parse object PFObject
    let post = PFObject(className: "Post")
    
    // Add relevant fields to the object
    post["media"] = getPFFileFromImage(image: image) // PFFile column type
    post["author"] = PFUser.current() // Pointer column type that points to PFUser
    post["caption"] = caption
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
  
  // helper to URL of the file we want to save in
  
  var photosURL: URL {
    return documentURL.appendingPathComponent("photos.json")
  }
  
  
  //convenience var to establish document path. Need to do first becuase it returns an array
  
  var documentURL: URL {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    return URL(fileURLWithPath: path)
  }
  
//  let applicationDocumentsDirectory: URL = {
//    let paths = FileManager.default.urlsForDirectory(
//      return paths[0]
//  }()
  
  
}
