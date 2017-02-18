//
//  PostStorage.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/18/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import Foundation

class PostStorage {
  
  private var _photos: [Post]!
  
  init() {
    // read the photos from a file / parse
    
    // if there aren't any, create an empty array
    
   _photos = readPhotosFromFile() ?? [Post]()
    
  }

  
  // Persistence
  
  func readPhotosFromFile() -> [Post]{
    
    
    return [Post]()
  }
  
  func writeToFile() {
    // we want to create JSON Data from "objects"
    let data = try! JSONSerialization.data(withJSONObject: _photos, options: .prettyPrinted)
    
    // Print URL for debugging
    print(photosURL)
    
    // we are taking an array of strings, and producing bytes.  then we write them.
    // Write the data to the "datesFile" URL
    
    try! data.write(to: photosURL)
    
  }
  var photosURL: URL {
  //  assert(photoID != nil, "No photo ID set")
    
    let filename = "Photo-/(photoID!.intValue).jpg"
    
    //return applicationDocumentsDirectory.appendingPathComponent(filename) // p232
    return photosURL
  }
  

  
  
  
}
