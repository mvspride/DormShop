//
//  ProfileViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/7/23.
//

import UIKit
import Parse
class ProfileViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = PFUser.current()?.username

        // Do any additional setup after loading the view.
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
