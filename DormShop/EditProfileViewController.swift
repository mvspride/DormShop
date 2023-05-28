//
//  EditProfileViewController.swift
//  DormShop
//
//  Created by Giovane Barnes on 4/24/23.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var profileDescr: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    let myClass = MyClass.shared
    var currentUser =  MyClass.shared.getCurrentViewer()


    @IBAction func profileName(_ sender: Any) {
    }
    
    @IBAction func profileDescription(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileDescr.borderStyle = .roundedRect
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                self.view.addGestureRecognizer(tapGesture)
      
    }
    

    @IBAction func saveChanges(_ sender: Any) {
        if myClass.isUser(currentViewer: currentUser) {
            // Do something if the current viewer is a user
           
            print("No, I am user")
           
//            user["content"] = imageFile2
//            user["name"] = "name"
//            user["description"] = "new description"

//            user.saveInBackground()
//            self.currentUser["name"] = "NewName"
//            self.currentUser["description"] = "newDescription"
//            self.dismiss(animated: true, completion: nil)
//
//            self.currentUser.saveInBackground()
            
              PFUser.current()!["name"] = "greatness"
                   
              PFUser.current()!.saveInBackground()
            
              self.dismiss(animated: true, completion: nil)
            }
            
         else {
             // Do something if the current viewer is a business
             let business = PFObject(className: "Business")
            
             //  user["content"] = imageFile2
             business["name"] = "name"
             business["description"] = "new description"

             business.saveInBackground()
             
             
             print("Yes, I am business")
             self.dismiss(animated: true, completion: nil)
            }
        }
    //dismiss keyboard when user clicks anywhere on screen
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
  
    
    @IBAction func takePicture(_ sender: UIButton) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Camera Unavailable", message: "Sorry, the camera is not available.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the selected image from the info dictionary
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        // Set the image to the image view
        imageView.image = image
        
        // Dismiss the image picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePicture(_ sender: UIButton) {

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    
    
}
