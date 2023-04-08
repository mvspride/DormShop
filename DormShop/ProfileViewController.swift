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

