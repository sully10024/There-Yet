//
//  AddressBookTableViewController.swift
//  Geotify
//
//  Created by Sullivan, Clark on 1/31/17.
//  Copyright © 2017 Clay Sullivan. All rights reserved.
//

import UIKit

class AddressBookViewController: UIViewController {
  
  
  
    // create the addressBook array
    static var addressList: [Address] = []
    var lastIndexInAddressListAdded = 0
  
  // outlet for the tableView
  @IBOutlet weak var tableView: UITableView!
  
    // for dismissing the addressbook
    @IBAction func onCancel(_ sender: AnyObject) {
      dismiss(animated: true, completion: nil)
    }
  
  @IBAction func onAddButtonPressed(_ sender: Any) {
    let alert = UIAlertController(title: nil, message: "Enter an address using the Standard for US and Canadian Address Formatting:", preferredStyle: .alert)
    
    alert.addTextField { (addressLabel) in
      addressLabel.placeholder = "Name of Contact"
    }
    alert.addTextField { (addressLineOne) in
      addressLineOne.placeholder = "Street Address"
    }
    alert.addTextField { (addressLineTwo) in
      addressLineTwo.placeholder = "City, State/Province, ZIP/Postal"
    }
    
    // reads the things that the user enters
    var addressArray = [String]()
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      addressArray.append((alert?.textFields![0].text)!)
      addressArray.append((alert?.textFields![1].text)!)
      addressArray.append((alert?.textFields![2].text)!)
      
      let newAddress = Address(newAddressArray: addressArray)
      AddressBookViewController.addressList.append(newAddress)
      
    }))

    self.present(alert, animated: true, completion: nil)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnSwipe = true // hiding the navigation bar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddressBookViewController.addressList.count
    }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddressViewCell
    
    // Configure the cell...
    cell.backgroundColor = UIColor.clear
    cell.labelOutlet.text = AddressBookViewController.addressList[indexPath.row].getAddressLabel()
    cell.lineOneOutlet.text = AddressBookViewController.addressList[indexPath.row].getAddressLineOne()
    cell.lineTwoOutlet.text = AddressBookViewController.addressList[indexPath.row].getAddressLineTwo()
    lastIndexInAddressListAdded = indexPath.row
    return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
