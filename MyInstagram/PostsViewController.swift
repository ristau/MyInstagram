//
//  PostsViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit


class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  

  var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

      self.navigationController?.navigationBar.barStyle = .black
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // MARK: - TABLEVIEW METHODS
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    headerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    
    let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
    profileView.clipsToBounds = true
    profileView.layer.cornerRadius = 15
    profileView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
    profileView.layer.borderWidth = 1;
    
    // set avatar 
//    profileView.setImageWithURL(URL(string"")!)
//    headerView.addSubview(profileView)

    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
   
    var height: CGFloat
    
    height = 50
    
    return height
  }

  func numberOfSections(in tableView: UITableView) -> Int {

    return posts.count 
 
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
    
  return cell 
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
  










