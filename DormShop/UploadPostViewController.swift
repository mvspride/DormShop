//
//  UploadPostViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/13/23.
//

import UIKit
import Parse

class UploadPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    var currentUser =  PFUser.current()!
    var businesses = [PFObject]()
    var filteredBusinesses = [PFObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.keyboardType = .decimalPad
        priceTextField.placeholder = "Enter price here"
        
        captionTextField.placeholder = "Enter caption here"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.starts(with: "-") ?? false {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == captionTextField {
            let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;':\"<>,.?/\\ ") // add any other special characters you want to allow
            let characterSet = CharacterSet(charactersIn: string)
            let maxLength = 300
            
            // Check if the new text would exceed the character limit
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            if newText.count > maxLength {
                return false
            }
            
            // Check if the new characters are allowed
            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }
            
            // Otherwise, allow the edit
            return true
        } else {
            let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    }
    
    @IBAction func toggleSwitchValueChanged(_ sender: UISwitch) {
        // Get a reference to the label and text field
        let myLabel = self.view.viewWithTag(1) as! UILabel
        let myTextField = self.view.viewWithTag(2) as! UITextField
        
        // Hide or show the label and text field based on the state of the toggle switch
        myLabel.isHidden = !sender.isOn
        myTextField.isHidden = !sender.isOn
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func choosePicture(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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
    
    func queryCampusPost(){
        let BusinessQuery = PFQuery(className: "Business")
        
        BusinessQuery.findObjectsInBackground{(Businesses,error) in
            if Businesses != nil {
                
            }
        }
    }
    
    //    @IBAction func BusinessFeedGalleryGenerate(_ sender: UIButton) {
    //        let post = PFObject(className: "Posts")
    //        post["BusinessId"] = PFUser.current()!
    //        post["BusinessName"] = [PFUser.current()!]
    //        post["numOfComments"] = 0
    //        post["likedPosts"] = []
    //
    //        post.saveInBackground()
    //
    //            (success,error) in if success{
    //                print("saved")
    //            }else{
    //                print("error!")
    //            }
    
    //        let inventory = PFObject(className: "Inventory")
    //        inventory["author"] = PFUser.current()!
    //        inventory["following"] = [PFUser.current()!]
    //        inventory["savedPosts"] = []
    //        inventory["likedPosts"] = []
    //
    //        inventory.saveInBackground()
    //
    //            (success,error) in if success{
    //                print("saved")
    //            }else{
    //                print("error!")
//}
    

    
}
