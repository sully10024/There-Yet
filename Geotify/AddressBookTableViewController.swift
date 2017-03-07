//
//  AddressBookTableViewController.swift
//  Geotify
//
//  Created by Sullivan, Clark on 1/31/17.
//  Copyright © 2017 Clay Sullivan. All rights reserved.
//

import UIKit

class AddressBookTableViewController: UITableViewController {
  
  
  
    // create the addressBook array
    static var addressList: [Address] = []
  
    // for dismissing the addressbook
    @IBAction func onCancel(_ sender: AnyObject) {
      dismiss(animated: true, completion: nil)
    }
  
  @IBAction func onAddButtonPressed(_ sender: Any) {
    let alert = UIAlertController(title: "New Address", message: "Enter an address:", preferredStyle: .alert)
    
    alert.addTextField { (addressLabel) in
      addressLabel.placeholder = "Address Label"
    }
    alert.addTextField { (addressLineOne) in
      addressLineOne.placeholder = "Address Line 1"
    }
    alert.addTextField { (addressLineTwo) in
      addressLineTwo.placeholder = "Address Line 2"
    }
    
    // reads the things that the user enters
    var addressArray = [String]()
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
      addressArray.append((alert?.textFields![0].text)!)
      addressArray.append((alert?.textFields![1].text)!)
      addressArray.append((alert?.textFields![2].text)!)
      
      let newAddress = Address(newAddressArray: addressArray)
      AddressBookTableViewController.addressList.append(newAddress)
      
    }))

    self.present(alert, animated: true, completion: nil)
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.hidesBarsOnSwipe = true
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
      return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddressBookTableViewController.addressList.count
    }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    
    let cellIdentifier = "Cell"
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddressViewCell
    
    // Configure the cell...
    cell.backgroundColor = UIColor.clear
    cell.labelOutlet.text = AddressBookTableViewController.addressList[indexPath.row].getAddressLabel()
    cell.lineOneOutlet.text = AddressBookTableViewController.addressList[indexPath.row].getAddressLineOne()
    cell.lineTwoOutlet.text = AddressBookTableViewController.addressList[indexPath.row].getAddressLineTwo()
    return cell
  }
  
  
  // Pass the address to the search bar
  override func prepare(for segue: UIStoryboardSegue,sender: Any?)
  {
    if segue.identifier == "searchFromAddressBook"
    {
      if let indexPath = tableView.indexPathForSelectedRow
      {
        let destinationController = segue.destination as! AddGeotificationViewController
        destinationController.passedAddress = AddressBookTableViewController.addressList[indexPath.row].getFullAddressAsString()
        AddGeotificationViewController.loadFromAddressBook(AddGeotificationViewController)
      }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
