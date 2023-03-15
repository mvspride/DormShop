//
//  MenuTableViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/11/23.
//

import UIKit
import Parse
class MenuTableViewController: UITableViewController {
    
    @IBOutlet var menuTable: UITableView!
    
    let menuList = ["person.fill" :"Switch account", "rectangle.portrait.and.arrow.forward.fill" : "Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.dataSource = self
        menuTable.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        let keys = Array(menuList.keys)
        let values = Array(menuList.values)
        cell.menuLabel.text = values[indexPath.row]
        cell.menuIcon.image = UIImage(systemName: keys[indexPath.row])
        
        return cell
    }
    //gets the row(menu) which the user selects
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let values = Array(menuList.values)
        let selectedItem = values[indexPath.row]
        
        switch selectedItem{
            case "Log out":
                logout()
            case "Switch account":
                switchAccounts()
        default:
            logout()
        }
        
    }
    
   func logout() {
       let alertController = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
               
               let switchAccount = UIAlertAction(title: "Switch account", style: .default) { (action) in
                   print("User selected option 1")
               }
               
               let logOut = UIAlertAction(title: "Log out", style: .default) { (action) in
                   PFUser.logOutInBackground()
                   let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                   self.present(loginVC, animated: true, completion: nil)
                   
               }
               
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
               }
       
               logOut.setValue(UIColor.red, forKey: "titleTextColor")
               alertController.addAction(switchAccount)
               alertController.addAction(logOut)
               alertController.addAction(cancelAction)
               
               present(alertController, animated: true, completion: nil)
    
    }
    
    func switchAccounts(){
        let alertController = UIAlertController(title: "Switch account", message: "", preferredStyle: .actionSheet)
        
        let currentAccount = UIAlertAction(title: PFUser.current()?.username, style: .default) { (action) in
            
        }
        
        let addAccount = UIAlertAction(title: "Add business account", style: .default) { (action) in
            let createBusinessVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateBusinessViewController") as! CreateBusinessViewController
            self.present(createBusinessVC, animated: true, completion: nil)
        }
        
       
        alertController.addAction(currentAccount)
        alertController.addAction(addAccount)
        
        present(alertController, animated: true, completion: nil)
    }
    
 
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
