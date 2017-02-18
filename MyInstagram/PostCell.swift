//
//  PostCell.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

  
  @IBOutlet weak var postImageView: UIImageView!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  @IBAction func onLike(_ sender: UIButton) {
  }
  
  @IBAction func onComment(_ sender: UIButton) {
  }
  
  @IBAction func onSend(_ sender: UIButton) {
  }
  
  @IBAction func onProfileTap(_ sender: UIButton) {
  }
  
}
