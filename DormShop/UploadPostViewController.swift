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
    
    var currentUser =  MyClass.shared.currentUser
    var businesses = [PFObject]()
    var filteredBusinesses = [PFObject]()
    var inventoryTrueFeedFalse = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.keyboardType = .decimalPad
        priceTextField.placeholder = "Enter price here"
        
        captionTextField.placeholder = "Enter caption here"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
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
        
        // Set feedTrueInventoryFalse to true if the switch is turned on
        inventoryTrueFeedFalse = sender.isOn
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
    
    @IBAction func BusinessFeedGalleryGenerate(_ sender: UIButton) {
        
        if inventoryTrueFeedFalse {
            
            let inventory = PFObject(className: "Inventory")
            
            inventory["BusinessId"] = currentUser.objectId
            inventory["BusinessName"] = currentUser["username"]
            inventory["description"] = captionTextField.text
            inventory["price"] = priceTextField.text
            
            guard let imageData2 = imageView.image?.jpegData(compressionQuality: 0.5) else {
                   return
               }
            
            let imageFile2 = PFFileObject(name: "image.jpg", data: imageData2)
            inventory["content"] = imageFile2
            
            inventory.saveInBackground()
        }
        else {
            
            let post = PFObject(className: "Posts")
            
            post["BusinessId"] = currentUser.objectId
            post["BusinessName"] = currentUser["username"]
            post["numOfComments"] = 0
            post["numOfLikes"] = 0
            post["description"] = captionTextField.text
            
            guard let imageData1 = imageView.image?.jpegData(compressionQuality: 0.5) else {
                   return
               }
            
            let imageFile1 = PFFileObject(name: "image.jpg", data: imageData1)
            post["content"] = imageFile1
            
            post.saveInBackground()
            
        }
    }
}
