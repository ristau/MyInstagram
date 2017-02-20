//
//  CaptureTableViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 2/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import CoreLocation


private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  formatter.timeStyle = .short
  return formatter
}()


class CaptureTableViewController: UITableViewController, UITextViewDelegate {

  @IBOutlet weak var captureImageView: UIImageView!
  @IBOutlet weak var addPhotoLabel: UILabel!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!

  var post: Post?
  var image: UIImage?

  var placeHolderText: String = "Description goes here"
  
  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var placemark: CLPlacemark? 
  
  var observer: Any!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
      listenForBackgroundNotification()

      descriptionTextView.delegate = self
      descriptionTextView.text = placeHolderText
      descriptionTextView.isUserInteractionEnabled = true
    
      image = captureImageView.image
    
      dateLabel.text = format(date: Date())
    


    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
          return 4
        default:
          return 0
      }
    }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if indexPath.section == 0 && indexPath.row == 0 {
        //...
    } else if indexPath.section == 1 && indexPath.row == 0 {
        tableView.deselectRow(at: indexPath, animated: true)
        pickPhoto()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
    switch(indexPath.section, indexPath.row) {
      
      case (0,0):
        return 88
      case (1,_):
        return captureImageView.isHidden ? 44: 260
      case (2,2):
        locationLabel.frame.size = CGSize(width: view.bounds.size.width - 115, height: 10000)
        locationLabel.sizeToFit()
        locationLabel.frame.origin.x = view.bounds.size.width - locationLabel.frame.size.width - 15
        return locationLabel.frame.size.height + 20
    default:
      return 44
      
    }
  }
  
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
  
  
  
  @IBAction func onCameraTap(_ sender: UIButton) {
    print("Pressed on camera")

  }
  
  @IBAction func done() {
    
    createPost { (success) -> Void in
      if success {
        
        Post.createNewPost(post: post!) { (success: Bool, error: Error?) -> Void in
          
          if success {
            print("Successful Post to Parse")
            self.captureImageView.image = nil
            self.descriptionTextView.text = ""
            self.goToPostsVC()
          }
          else {
            print("Can't post to parse")
          }
        }
      }
    }
  }
  
  func goToPostsVC() {
    let postsVC = self.storyboard?.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
    self.navigationController?.pushViewController(postsVC, animated: true)
  }
  
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
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
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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



