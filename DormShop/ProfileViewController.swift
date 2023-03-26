//
//  ProfileViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/7/23.
//

import UIKit
import Parse
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var profileNameBttn: UIButton!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBAction func switchBttn(_ sender: UIButton) {
           // Get a reference to the tab bar controller
           guard let tabBarController = self.tabBarController else { return }
           
           // Create a new view controller instance
           let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessInboxViewController")
           
           // Get the current list of view controllers and add the new one
           var viewControllers = tabBarController.viewControllers ?? []
           viewControllers.append(newViewController)
           
           // Set the modified list of view controllers back to the tab bar controller
           tabBarController.viewControllers = viewControllers
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        profileNameBttn.titleLabel?.text = PFUser.current()?.username

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileCell
            profileCell.profiledescription.text = "hello this is my photography jawn"
            return profileCell
        }
        else if indexPath.row == 1{
            let bttnsCell = tableView.dequeueReusableCell(withIdentifier: "bttnsCell") as! ProfileBttnsCell
            return bttnsCell
        }
        else{
            let itemsCell = tableView.dequeueReusableCell(withIdentifier: "itemsCell") as! ProfileItemsCell
            itemsCell.itemName.text = "new lashes"
            return itemsCell

        }


    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = CustomHeaderView()
            // configure the header view as needed
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
             return 10
         }
         return 0 // return 0 for non-desired sections to hide the header
    }


    
    
   



    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class CustomHeaderView: UIView {
    // add any desired subviews or properties
    
}
