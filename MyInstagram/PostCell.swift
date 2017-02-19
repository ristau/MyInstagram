//
//  PostCell.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCell: UITableViewCell {
  
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
  
  
    @IBOutlet weak var photoImageView: PFImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
  
    var postDescription: String!
  
  var post: PFObject! {
    didSet{
      
      self.photoImageView.file = post["photo"] as? PFFile
      self.photoImageView.loadInBackground()
      descriptionLabel.text = post["caption"] as? String
      dateLabel.text = post["date"] as? String
      
      
    }
  }
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
