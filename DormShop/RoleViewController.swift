//
//  RoleViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/9/23.
//

import UIKit
import Parse

class RoleViewController: UIViewController {
    
    let user = PFUser()
    
    @IBAction func businessBtn(_ sender: UIButton) {
        user["role"] = "Business"
        
    }
    
    @IBAction func customerBtm(_ sender: UIButton) {
        user["role"] = "Customer"
        let customer = PFObject(className: "Customer")
        customer["author"] = PFUser.current()!
        customer["following"] = [PFUser.current()!]
        customer["savedPosts"] = []
        customer["likedPosts"] = []

        user.saveInBackground()
        customer.saveInBackground(){
            (success,error) in if success{
                print("saved")
            }else{
                print("error!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
