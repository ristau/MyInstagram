//
//  CaptureTableViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import Dispatch
import Parse

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .short
  return formatter
}()


class CaptureTableViewController: UITableViewController, UITextViewDelegate {
  
  
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var logoutButton: UIButton!
  
  @IBOutlet weak var captureImageView: UIImageView!
  @IBOutlet weak var addPhotoLabel: UILabel!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!

  var post: Post?
  var image: UIImage?
  var categoryPlaceholderName = "No Category"
  var categoryName: String?

  var placeHolderText: String = "Description goes here"
  
  var observer: Any!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
     listenForBackgroundNotification()

      descriptionTextView.delegate = self
      descriptionTextView.text = placeHolderText
      descriptionTextView.isUserInteractionEnabled = true
      categoryName = categoryPlaceholderName
      categoryLabel.text = categoryName
    
      dateLabel.text = format(date: Date())
    
      self.doneButton.layer.cornerRadius = 4
      self.logoutButton.layer.cornerRadius = 4 

    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
  
 override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      dateLabel.text = format(date: Date())

  }
  
  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      switch section {
        case 0:
          return 2
        case 1:
          return 1
        case 2:
          return 1
        default:
          return 0
      }
    }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if indexPath.section == 0 && indexPath.row == 0 {

    } else if indexPath.section == 1 && indexPath.row == 0 {
        print("Selected tableview cell")
        tableView.deselectRow(at: indexPath, animated: true)
        pickPhoto()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
    switch(indexPath.section, indexPath.row) {
      
      case (0,0):
        return 88
      case (1,_):
        return captureImageView.isHidden ? 44: 280
      default:
        return 44
      
    }
  }
  
    // Override to support conditional editing of the table view.
   // override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
     //   return true
   // }
  

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
  
  // MARK: - TEXT VIEW METHODS 
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
   
    if textView == descriptionTextView && textView.text == placeHolderText {
      moveCursorToStart(textView: descriptionTextView)

      print("Moving Cursor to Start")
    }
    return true
  }
  
  func moveCursorToStart(textView: UITextView)
  {
    DispatchQueue.main.async {
      self.descriptionTextView.selectedRange = NSMakeRange(0,0)
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
   
    let newLength = textView.text.utf16.count + text.utf16.count - range.length
    
    if newLength > 0 {
      
      if textView == descriptionTextView && descriptionTextView.text == placeHolderText
      {
        applyNonPlaceholderStyle(text: textView)
        descriptionTextView.text = ""
      }
    }
    return true
  }
  
  func applyPlaceholderStyle(text: UITextView, phText: String) {
    descriptionTextView.textColor = UIColor.lightGray
    descriptionTextView.text = phText
  }
  
  func applyNonPlaceholderStyle(text: UITextView) {
    descriptionTextView.textColor = UIColor.darkText
    descriptionTextView.alpha = 1.0
  }

  // MARK: = PICK CATEGORY 
  
  @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
    
    let controller = segue.source as! CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
    
  }
  
  
  
  // MARK: - SHOW IMAGE

  func show(image: UIImage) {
    
    captureImageView.image = image
    captureImageView.isHidden = false
    captureImageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
    addPhotoLabel.isHidden = true
    
  }
  

  // MARK: - FORMAT DATE 
  
  func format(date: Date) -> String {
    
    return dateFormatter.string(from: date)
    
  }
  
  // MARK: - CREATE POST
  func createPost(completion: (_ success: Bool) -> Void) {
    
    post = Post(photoCaption: descriptionTextView.text!, capturedImage: image!, currDateString: dateLabel.text!)
    completion(true)
  
  }
  
  // MARK: - Completing the Post
  
  
  @IBAction func done() {
    
    let hudView = HudView.hud(inView: navigationController!.view, animated: true)
    
    hudView.text = "Done!"
    
    createPost { (success) -> Void in
      if success {
        
        Post.createNewPost(post: post!) { (success: Bool, error: Error?) -> Void in
          
          if success {
            print("Successful Post to Parse")
        
      
           
            afterDelay(0.6) {
              hudView.isHidden = true
              self.captureImageView.image = nil
              self.descriptionTextView.text = ""
              self.captureImageView.isHidden = true
              self.addPhotoLabel.isHidden = false
              self.descriptionTextView.text = self.placeHolderText
              self.descriptionTextView.isUserInteractionEnabled = true
              self.applyPlaceholderStyle(text: self.descriptionTextView, phText: self.placeHolderText)
              self.dateLabel.text = self.format(date: Date())
              self.tableView.reloadData()
              self.dismiss(animated: true, completion: nil)
  //            self.returnMainMenu()
              // self.navigationController?.popToRootViewController(animated: true)
              // self.presentingViewController?.dismiss(animated: false, completion: nil)
            //  self.tabBarController?.dismiss(animated: true, completion: nil)
              // self.dismiss(animated: true, completion: nil)
             }
          }
          else {
            print("Can't post to parse")
          }
        }
      }
    }
  }
  
  func returnMainMenu() {
    // save the presenting ViewController
    if let tabBarController = self.presentingViewController as? UITabBarController {
      self.dismiss(animated: true) {
        tabBarController.selectedIndex = 0
      }
    }
  }
  
  
  @IBAction func cancel() {

    print("Tapped on cancel")
    self.descriptionTextView.text = ""
    categoryLabel.text = categoryPlaceholderName
    dateLabel.text = ""
    captureImageView.image = nil
    view.endEditing(true)
    tabBarController?.selectedIndex = 0
    
  }
  
  
  func listenForBackgroundNotification() {
    
    observer = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: OperationQueue.main) {[weak self] _ in
      
      if let strongSelf = self {
        if strongSelf.presentedViewController != nil {
          strongSelf.dismiss(animated: false, completion: nil)
        }
        strongSelf.descriptionTextView.resignFirstResponder()
      }
    }
  }
  
  deinit{
    print("*** deinit\(self)")  // NOT PRINTING TO CONSOLE, LEAKING MEMORY
    if let observer = observer {
      NotificationCenter.default.removeObserver(observer)
    }
  }
  
  
    // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickCategory" {
      let controller = segue.destination as! CategoryPickerViewController
      controller.selectedCategoryName = categoryName!
    }
  
  
  }
  

}

extension CaptureTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func takePhotoWithCamera() {
    
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
   
    image = info[UIImagePickerControllerEditedImage] as? UIImage
    
    if let theImage = image{
      show(image: theImage)
    }

    tableView.reloadData()
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



