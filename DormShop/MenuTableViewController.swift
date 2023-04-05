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
    var currentUser =  PFUser.current() as! PFObject
    var userBusinesses = [PFObject]()
    
    let menuList = ["person.fill" :"Switch account", "rectangle.portrait.and.arrow.forward.fill" : "Log out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.dataSource = self
        menuTable.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        getUserBusinesses()

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
    //gets the row(menu) the user selects
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
    

    func getUserBusinesses(){
        let businessQuery = PFQuery(className: "Business")
        businessQuery.whereKey("owner", contains: currentUser.objectId)
        businessQuery.findObjectsInBackground{(businesses,error) in
            if businesses != nil {
                self.userBusinesses = businesses!
            }
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("hello worldd9------------------------------")
//        print(segue.destination)
//        if let destinationVC = segue.destination as? ProfileViewController{
//            destinationVC.currentUser = self.currentUser
//        }
//    }


  

    
    func switchAccounts(){
        let alertController = UIAlertController(title: "Switch account", message: "", preferredStyle: .actionSheet)
        //list user current account
        let currentAccount = UIAlertAction(title: PFUser.current()?.username, style: .default) { (action) in
            MyClass.shared.currentUser = PFUser.current()!
        }
        alertController.addAction(currentAccount)
        
        //list all user businesses
        for business in userBusinesses{
            let account = UIAlertAction(title: business["username"] as? String, style: .default) { (action) in
                self.currentUser = business
                MyClass.shared.currentUser = business
                self.tabBarController?.viewControllers![0].tabBarItem = nil
                self.tabBarController?.viewControllers![1].tabBarItem = nil

            }
          
            alertController.addAction(account)
            // Perform the segue

        }
        
        //lets user create a business
        let addAccount = UIAlertAction(title: "Add business account", style: .default) { (action) in
            let createBusinessVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateBusinessViewController") as! CreateBusinessViewController
            
            self.present(createBusinessVC, animated: true, completion: nil)
        }
        
       
        alertController.addAction(addAccount)
        
        present(alertController, animated: true, completion: nil)
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
class MyClass {
    static let shared = MyClass()
    var currentUser: PFObject =   PFUser.current()!

    func getCurrentViewer()-> PFObject{
        if isUser(currentViewer: currentUser){
            let query = PFUser.query()!
            query.whereKey("objectId", contains: self.currentUser.objectId)
            query.limit = 3
            query.findObjectsInBackground{(users,error) in
                if users != nil {
                    let user = users![0] as? PFUser
                    self.currentUser = user ?? self.currentUser
                }
            }
            //print(currentUser)
        }else{
            let query = PFQuery(className: "Business")
            query.whereKey("objectId", contains: self.currentUser.objectId)
            query.limit = 3
            query.findObjectsInBackground{(businesses,error) in
                if businesses != nil {
                    let business = businesses![0] as? PFObject
                    self.currentUser = business ?? self.currentUser
                }
            }
          
        }
        return currentUser
    }
    
    //returns true if currentViewer is a user. returns false if currentViewer is a business
    func isUser(currentViewer: PFObject) -> Bool{
        if currentViewer.isMember(of: PFUser.self){
            return true
        }
        return false
    }
}
