//
//  LaunchAnimationViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 3/8/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class LaunchAnimationViewController: UIViewController {

  
  @IBOutlet weak var launchImageView: UIImageView!

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        rotateImage()
    }


  func rotateImage() {
    UIView.animate(withDuration: 4.0, delay: 0.0, options: .curveEaseInOut, animations: { () -> Void in
      
      for _ in 1...10  {
        self.launchImageView.transform = self.launchImageView.transform.rotated(by: CGFloat(M_PI_2))
      }
      self.launchImageView.alpha = 0.0
    }) { (finished) -> Void in
      self.goToLogin()
    }
  }
  
  func goToLogin() {
    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    self.present(loginVC, animated: true, completion: nil)

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
