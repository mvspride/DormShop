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
    
    var businesses = [PFObject]()
    
    @IBAction func createBusinessBttn(_ sender: UIButton) {
        let business = PFObject(className:"Business")
        business["username"] = businessNameField.text
        business["owner"] = PFUser.current()
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

        // Do any additional setup after loading the view.
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
