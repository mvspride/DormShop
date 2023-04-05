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
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var profileDescr: UILabel!
        
    @IBOutlet weak var headerView: UIView!
    var headerHeight: CGFloat = 200 // Set the height of the header view

    
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
        let currentUser = MyClass.shared.getCurrentViewer()


        // Create a custom view for the header
//                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 50))
//                headerView.backgroundColor = .lightGray
//
//                // Create a button and add it to the header view
//                let button1 = UIButton(type: .system)
//                button1.setTitle("Button 1", for: .normal)
//                button1.frame = CGRect(x: 20, y: 10, width: 80, height: 30)
//                headerView.addSubview(button1)
//
//                // Create another button and add it to the header view
//                let button2 = UIButton(type: .system)
//                button2.setTitle("Button 2", for: .normal)
//                button2.frame = CGRect(x: 120, y: 10, width: 80, height: 30)
//                headerView.addSubview(button2)
//
//                // Set the header view as the table view's tableHeaderView
//                profileTableView.tableHeaderView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let currentUser = MyClass.shared.getCurrentViewer()

        let username = currentUser["username"] as? String
        profileNameBttn.setTitle(username, for: .normal)
        profileDescr.text = currentUser["description"] as? String

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0{
//            let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileCell
//            profileCell.profiledescription.text = "hello this is my photography jawn"
//            return profileCell
//        }
//        else if indexPath.row == 1{
//            let bttnsCell = tableView.dequeueReusableCell(withIdentifier: "bttnsCell") as! ProfileBttnsCell
//            return bttnsCell
//        }
//        else{
//            let itemsCell = tableView.dequeueReusableCell(withIdentifier: "itemsCell") as! ProfileItemsCell
//            itemsCell.itemName.text = "new lashes"
//            return itemsCell
//
//        }
        let bttnsCell = tableView.dequeueReusableCell(withIdentifier: "bttnsCell") as! ProfileBttnsCell
                    return bttnsCell

    }
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 50 // return 0 for non-desired sections to hide the header
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

