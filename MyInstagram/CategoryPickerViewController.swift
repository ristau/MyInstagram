//
//  CategoryPickerViewController.swift
//  MyInstagram
//
//  Created by Barbara Ristau on 3/8/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  
  @IBOutlet weak var tableView: UITableView!
  
  var selectedCategoryName = ""
  
  let categories = [
    "No Category",
    "Business",
    "Friends",
    "Family",
    "Local Sights",
    "Travel" ]
  
  var selectedIndexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.dataSource = self
      tableView.delegate = self
      
      for i in 0..<categories.count {
        if categories[i] == selectedCategoryName {
          selectedIndexPath = IndexPath(row: i, section: 0)
          break
        }
      }
    }

  //MARK: - UITableViewDataSource 
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    let categoryName = categories[indexPath.row]
    cell.textLabel!.text = categoryName
    
    if categoryName == selectedCategoryName {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row != selectedIndexPath.row {
      if let newCell = tableView.cellForRow(at: indexPath){
          newCell.accessoryType = .checkmark
      }
      if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
        oldCell.accessoryType = .none
      }
      selectedIndexPath = indexPath
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickedCategory" {
    let cell = sender as! UITableViewCell
    if let indexPath = tableView.indexPath(for: cell){
      selectedCategoryName = categories[indexPath.row]
    }
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
