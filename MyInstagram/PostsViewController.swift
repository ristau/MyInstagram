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
  
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var logoutButton: UIButton!
  

    override func viewDidLoad() {
        super.viewDidLoad()

      self.navigationItem.title = "My Posts"
      self.logoutButton.layer.cornerRadius = 4
      
      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
      
    }

  override func viewWillAppear(_ animated: Bool) {
    
    fetchParsePosts()
  
  }
  
  
  // MARK: - TABLEVIEW METHODS
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    headerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
   // headerView.backgroundColor = UIColor(red:0.00, green:0.67, blue:0.93, alpha:0.3)
    
    // set & load avatar image
    var profileView = UIImageView()
    let myImage: UIImage = UIImage(named: "bfrfeb17_120x160")!
    profileView = UIImageView(image: myImage)
    profileView.frame = CGRect(x: 20, y: 10, width: 30, height: 30)
    profileView.clipsToBounds = true
    profileView.layer.cornerRadius = 15
    profileView.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
    profileView.layer.borderWidth = 1;
    headerView.addSubview(profileView)
    
    // set & load user name 
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    label.center = CGPoint(x: 130, y: 25)
    label.textColor = UIColor.lightGray
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    
    let post = postArray[section]
    
    if let authorName = post["fullname"] as? String {
      label.text = authorName
    } else {
      label.text = "Fay Ristau"
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
    cell.favoriteButton.tag = indexPath.row
    cell.commentButton.tag = indexPath.row
    cell.sendButton.tag = indexPath.row
    
    cell.contentView.setNeedsLayout()
    cell.contentView.layoutIfNeeded()
    
    return cell 
  }
  
  //MARK: - FETCH POSTS FROM PARSE
  
  func fetchParsePosts() {
    
    let query = PFQuery(className: "Post")
    
    query.order(byDescending: "_created_at")
    query.includeKey("author")
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
    
    self.tableView.reloadData()
  
  }

  // MARK: - ACTION BUTTONS 
  
  
  @IBAction func onFavorite(_ sender: UIButton) {
    print("Tapped on Favorite")
  }
  
  @IBAction func onComment(_ sender: UIButton) {
    print("Tapped on Comment")
  }
  
  @IBAction func onSend(_ sender: UIButton) {
    print("Tapped on Send")
  }
  
  @IBAction func onProfileTap(_ sender: UIButton) {
    print("Tapped on Profile") 
  }
  
  @IBAction func onLogout(_ sender: UIButton) {
    print("Logging Out.  Goodbye.")
    
    PFUser.logOut()
    dismiss(animated: true, completion: nil)
    
    
  }
  
  
  
  
  

  
    // MARK: - Navigation

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
  










