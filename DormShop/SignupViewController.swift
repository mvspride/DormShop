//
//  SignupViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/6/23.
//

import UIKit
import Parse

class SignupViewController: UIViewController{
    
    @IBOutlet weak var usernametxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var confirmPasswordtxt: UITextField!
    @IBOutlet weak var sigupErrorTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sigupErrorTxt.text = ""
        self.hideKeyboardWhenTappedAround()

    }
    @IBAction func signUp(_ sender: UIButton){
        if passwordtxt.text != confirmPasswordtxt.text{
            sigupErrorTxt.text = "passwords do not match!"
        }else{
            let user = PFUser()
            user.username = usernametxt.text
            user.email  = emailtxt.text
            user.password = passwordtxt.text
            
            user.signUpInBackground{
                (success,error) in if success{
                    PFUser.logOut()
                    self.showPopUp(email: user.email ?? "default", username: user.username ?? "default")
                }else{
                    PFUser.logOut()
                    print("Error: \(String(describing: error?.localizedDescription))")
                    self.sigupErrorTxt.text = "\(error?.localizedDescription ?? "")"
    
                }
            }
        }
    }
    
    @objc func showPopUp(email: String, username : String){
        let alert = UIAlertController(title: "We've sent a verification email to: \(email) ",message: "click the link in the email to verify your account. If you can't find the email check your spam folder", preferredStyle: .alert)
        //define action
        let cancelAction = UIAlertAction(title: "ok", style: .default){(action) in print(action)
            
        }
        //add to alert
        alert.addAction(cancelAction)
        present(alert, animated: true,completion: nil)
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
