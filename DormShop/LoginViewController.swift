//
//  LoginViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/6/23.
//

import UIKit
import Parse


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginErrorTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        loginErrorTxt.text = ""


        
    }
  
    
    
    @IBAction func login(_ sender: UIButton) {
        let username = usernameTxt.text!
        let password = passwordTxt.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password){ [self]
            (user, error) in
            if user != nil {
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                let isNewUser = user!["isNewUser"] as! Bool
                //if its the user 1st time login in, send to the choose path VC
                    if(isNewUser){
                        self.performSegue(withIdentifier: "toFeedSegue", sender: nil)
                        user!["isNewUser"] = false
                        user?.saveInBackground()
                    }
                    else{
                        self.performSegue(withIdentifier: "toFeedSegue", sender: nil)
                        
                    }
             
            }else{
                print("Error: \(String(describing: error?.localizedDescription))")
                self.loginErrorTxt.text = "\(error?.localizedDescription ?? "")"
            }
        }
        
    }
    
    
    
    
    


}

