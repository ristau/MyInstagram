//
//  PostsViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var postArray: [PFObject] = []
  let HeaderViewIdentifier = "TableViewHeaderView"
  var date: Date?
  var myImage: PFImageView!
  var fullName: String!
  var hudView: HudView?
  
  var tapGesture: UITapGestureRecognizer!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var logoutButton: UIButton!
  

    override func viewDidLoad() {
        super.viewDidLoad()

      self.navigationItem.title = "My Posts"
      self.logoutButton.layer.cornerRadius = 4
      
      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
      
      tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.goToProfileView(_:)))
     
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    User.currentUser = PFUser.current()
    fullName = getCurrentUserName()
    print("Current User: \(fullName!)")
    fetchParsePosts()
    loadUserImage()
  
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
  }
  
 
  
  
  // MARK: - TABLEVIEW METHODS
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    headerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
   // headerView.backgroundColor = UIColor(red:0.00, green:0.67, blue:0.93, alpha:0.3)

    // set & load avatar image
    var profileView = UIImageView()
    profileView = UIImageView(image: myImage.image)
    profileView.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
    profileView.clipsToBounds = true
    profileView.layer.cornerRadius = 15
    profileView.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
    profileView.layer.borderWidth = 1;
    headerView.addSubview(profileView)
    
    
    profileView.isUserInteractionEnabled = true
    profileView.addGestureRecognizer(tapGesture)
    
    
    // set & load user name
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    label.center = CGPoint(x: 130, y: 25)
    label.textColor = UIColor.lightGray
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(tapGesture)
    
    let post = postArray[section]
    
    if let authorName = post["fullname"] as? String {
      label.text = authorName
    } else {
      label.text = ""
    }
    
    headerView.addSubview(label)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
   
    var height: CGFloat
    
    height = 50
    
    return height
  }

  func numberOfSections(in tableView: UITableView) -> Int {

    return postArray.count
 
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
    cell.selectionStyle = .none
    
    let post = postArray[indexPath.section]
    cell.post = post

    // add tags for action buttons 
    cell.favoriteButton.tag = indexPath.section
    cell.commentButton.tag = indexPath.section
    cell.sendButton.tag = indexPath.section
    
    setFavoriteLabels(post: cell.post)
    
    cell.contentView.setNeedsLayout()
    cell.contentView.layoutIfNeeded()
    
    return cell 
  }
  
  //MARK: - FETCH POSTS FROM PARSE
  
  func fetchParsePosts() {
    
    let query = PFQuery(className: "Post")
    
    query.order(byDescending: "_created_at")
    
    query.includeKey("author")
    query.whereKey("fullname", equalTo: fullName)
    query.limit = 20
    
    query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
      if let posts = posts {
        
        self.postArray = posts
        self.tableView.reloadData()
        
        print("Retrieved the posts")
      } else {
        print(error?.localizedDescription as Any)
      }
    }
  }
  
  
  func loadUserImage() {
    
    // get profile image from Parse
    myImage = PFImageView()
    
    if User.currentUser?["profile_image"] != nil {
      myImage.file = User.currentUser?["profile_image"] as? PFFile
      myImage.loadInBackground()
    } else {
      myImage.image = UIImage(named: "placeholderBlue64")!
    }
  }
  
  func getCurrentUserName() -> String {
    
    let _firstname = User.currentUser!["firstname"]
    let _lastname = User.currentUser!.object(forKey: "lastname")
    
    // convert first and last name to full name
    let charSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
    let unformattedFirstName = String(describing: _firstname!)
    let firstName = unformattedFirstName.components(separatedBy: charSet).joined(separator: "")
    let unformattedLastName = String(describing: _lastname!)
    let lastName = unformattedLastName.components(separatedBy: charSet).joined(separator: "")
    
    let currentUserFullName = firstName + " " + lastName
    return currentUserFullName
  }

  // MARK: - SET LABELS 
  
  func setFavoriteLabels(post: PFObject) {
    
    if let favorited = post["favorited"] as? Bool {
      
      if favorited == true {
        print("Favorited")
      }
    }
  }
  
  
  // MARK: - ACTION BUTTONS 
  
  
  @IBAction func onFavorite(_ sender: UIButton) {
    print("Tapped on Favorite")

    let button = sender 
    let index = button.tag
    print("Index: \(index)")
    
    let post = postArray[index]
    
    Post.saveAsFavorite(post: post, withCompletion: { (success: Bool, error: Error?) -> Void in
      if success {
        print("Successful Post to Parse")
        let favorited = post["favorited"] as? Bool
        print("Favorite Status is: \(favorited!)")
      }  else {
        print("Can't post to parse")
      
      }
    })
    tableView.reloadData()
  }
  
  
  
  @IBAction func onComment(_ sender: UIButton) {
    print("Tapped on Comment")
  }
  
  @IBAction func onSend(_ sender: UIButton) {
    print("Tapped on Send")
  }
  
  
  @IBAction func onLogout(_ sender: UIButton) {
    
     let hudView = HudView.hud(inView: self.view, animated: true)
     hudView.text = "Goodbye!"
   
    afterDelay(1.0) {
      hudView.isHidden = true
      hudView.removeFromSuperview()
      User.logout()
    }
  }

    // MARK: - Navigation
  
  func goToProfileView(_ sender: UITapGestureRecognizer) {
    print("Tapped on goToProfile")
       tabBarController?.selectedIndex = 2
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.identifier == "FromHomeToProfile" {
       
        print("Going to Profile View from the home timeline ")
        let button = sender as! UIButton
        let index = button.tag
        let post = postArray[index]
        let profileVC = segue.destination as! ProfileViewController
        profileVC.post = post 
      
      }
    }
  
  
}
  










