//
//  CreateBusinessViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/13/23.
//

import UIKit
import Parse

class CreateBusinessViewController: UIViewController {

    @IBOutlet weak var businessNameField: UITextField!
    
    @IBOutlet weak var businessDescription: UITextField!
    
    @IBOutlet weak var businessCategory: UITextField!
    
    @IBOutlet weak var businessLocation: UITextField!
    
    var businesses = [PFObject]()
    
    var currentUser = PFUser.current()
    
    @IBAction func createBusinessBttn(_ sender: UIButton) {
        let business = PFObject(className:"Business")
        business["username"] = businessNameField.text
        business["owner"] = PFUser.current()
        business["description"] = businessDescription.text
        business["category"] = businessCategory.text
        business["location"] = businessLocation.text
        business["Rating"] = "0.0"
        business.saveInBackground { (success, error) in
            if (success) {
                print("Object saved successfully.")
                self.performSegue(withIdentifier: "toBnsProfileSegue", sender: nil)

            } else {
                if let error = error {
                    print("Error saving object: \(error.localizedDescription)")
                } else {
                    print("Unknown error occurred while saving object.")
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Business")
            query.whereKey("owner", containedIn: [PFUser.current()!])
            query.limit = 20
            query.findObjectsInBackground{(businesses,error) in
                if businesses != nil {
                    self.businesses = businesses!
                    print(self.businesses)
            }
            // Do any additional setup after loading the view.
        }
        
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
