import UIKit
import Parse

class UploadPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var uploadPhotoButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    let myClass = MyClass.shared
    
    var currentUser = MyClass.shared.getCurrentViewer()
    var businesses = [PFObject]()
    var filteredBusinesses = [PFObject]()
    var inventoryTrueFeedFalse = false
    var previousPriceText = ""
    var notificationBoolean = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = MyClass.shared.getCurrentViewer()
    
        if myClass.isUser(currentViewer: currentUser) {
            if notificationBoolean {
                // Do something if the current viewer is a user
                let alertController = UIAlertController(title: "Business Feature", message: "Unable to Save", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                submitButton.isEnabled = false
                uploadPhotoButton.isEnabled = false
                notificationBoolean = false
            }
            
        } else {
            submitButton.isEnabled = true
            uploadPhotoButton.isEnabled = true
        }
        
        priceTextField.keyboardType = .decimalPad
        priceTextField.placeholder = "Enter Price here"
        
        captionTextField.borderStyle = .roundedRect
        captionTextField.placeholder = "Enter Caption here"
        
        productName.placeholder = "Enter Product Name here"
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Set the text field delegates
        captionTextField.delegate = self
        productName.delegate = self
        priceTextField.delegate = self
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardSize.height - 0
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func showKeyboard() {
        priceTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentUser = MyClass.shared.getCurrentViewer()
    
        if myClass.isUser(currentViewer: currentUser) {
            if notificationBoolean {
                // Do something if the current viewer is a user
                let alertController = UIAlertController(title: "Business Feature", message: "Unable to Save", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                submitButton.isEnabled = false
                uploadPhotoButton.isEnabled = false
                notificationBoolean = false
            }
            
        } else {
            submitButton.isEnabled = true
            uploadPhotoButton.isEnabled = true
        }
        
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
            let maxLength = 200
            
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
        }  else if textField == productName {
            let maxLength = 100
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= maxLength
            
        }  else if textField == priceTextField {
            let existingText = textField.text ?? ""
            let newCharacters = string
            
            // Allow backspace
            if newCharacters.isEmpty {
                return true
            }
            
            // Restrict to only numeric characters
            let numericSet = CharacterSet(charactersIn: "0123456789.")
            if newCharacters.rangeOfCharacter(from: numericSet.inverted) != nil {
                return false
            }
            
            // Restrict to only two decimal places
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            if existingText.contains(decimalSeparator) && string.contains(decimalSeparator) {
                return false
            }
            
            // Check if input is an integer and append ".00" if so
            let separatedText = existingText.components(separatedBy: decimalSeparator)
            if separatedText.count == 2 && separatedText[1].count == 2 {
                return false
            }
            
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
        let myLabel1 = self.view.viewWithTag(3) as! UILabel
        let myTextField1 = self.view.viewWithTag(4) as! UITextField
        
        
        // Hide or show the label and text field based on the state of the toggle switch
        myLabel.isHidden = !sender.isOn
        myTextField.isHidden = !sender.isOn
        myLabel1.isHidden = !sender.isOn
        myTextField1.isHidden = !sender.isOn
        
        // Set feedTrueInventoryFalse to true if the switch is turned on
        inventoryTrueFeedFalse = sender.isOn
        
        if sender.isOn {
            captionLabel.text = "Product Description"
            captionTextField.placeholder = "Enter Product Description here"
        } else {
            captionLabel.text = "Caption"
            captionTextField.placeholder = "Enter caption here"
        }
        
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        if myClass.isUser(currentViewer: currentUser) {
            // Do something if the current viewer is a user
            
        } else {
            // Do something if the current viewer is a business
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
    }
    
    @IBAction func choosePicture(_ sender: UIButton) {
        if myClass.isUser(currentViewer: currentUser) {
            // Do something if the current viewer is a user
            
        } else {
            // Do something if the current viewer is a business
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
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
    
    @IBAction func BusinessFeedGalleryGenerate(_ sender: UIButton) {
        
        if myClass.isUser(currentViewer: currentUser) {
            // Do something if the current viewer is a user
            
        } else {
            // Do something if the current viewer is a business
            if inventoryTrueFeedFalse {
                
                
                let inventory = PFObject(className: "Inventory")
                inventory["BusinessId"] = currentUser.objectId
                inventory["BusinessName"] = currentUser["username"]
                inventory["description"] = captionTextField.text
                inventory["price"] = priceTextField.text
                inventory["ProductName"] = productName.text
                
                guard let imageData2 = imageView.image?.jpegData(compressionQuality: 0.5) else {
                    return
                }
                
                let imageFile2 = PFFileObject(name: "image.jpg", data: imageData2)
                inventory["content"] = imageFile2
                
                inventory.saveInBackground()
                
                let alertController = UIAlertController(title: "Saved", message: "Saved to Inventory", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
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
                
                let alertController = UIAlertController(title: "Saved", message: "Saved to Feed", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                
            }
        }
    }

}
