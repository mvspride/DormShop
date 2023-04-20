//
//  CreateOrderViewController.swift
//  DormShop
//
//  Created by Giovane Barnes on 4/15/23.
//

import UIKit
import Parse

class CreateOrderViewController: UIViewController {

   
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var businessName: UILabel!
    
    @IBOutlet weak var productDescription: UITextField!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    var currentUser =  MyClass.shared.getCurrentViewer()
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var inventories = [PFObject]()
    
    var currentItemId: String = ""
    
    var priceGlobal: String = ""
    
    var businessId: String = ""
    
    var newPrice: Double = 0.0
    
    var quantity: Int = 0  {
        didSet {
            quantityLabel.text = "\(quantity)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quantityLabel.text = "\(quantity)"
        // Do any additional setup after loading the view.
        productDescription.borderStyle = .roundedRect
        productDescription.isUserInteractionEnabled = false
        
        print("-------------------------")
        print("Create Order Item Id:")
        print(currentItemId)
        print("Did ItemIdReturn")
        
        queryInventory()
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func queryInventory(){
            let currentUser = MyClass.shared.getCurrentViewer()
            let inventoryQuery = PFQuery(className: "Inventory")
        print("hello world")
        print(self.currentItemId)
        inventoryQuery.whereKey("objectId", equalTo: self.currentItemId)
            inventoryQuery.findObjectsInBackground{(inventory,error) in
                if inventory != nil {
                    self.inventories = inventory!
                    print(self.inventories)
                    let firstInventoryItem = self.inventories[0]
                    let businessName = firstInventoryItem["BusinessName"] as? String
                    let productName = firstInventoryItem["description"] as? String
                    self.priceGlobal = firstInventoryItem["price"] as! String
                    self.businessName.text = businessName
                    self.productDescription.text = productName
                    let imageFile = firstInventoryItem["content"] as? PFFileObject
                    let urlString = imageFile?.url! ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQP7ARHenfnGXcxCIhmDxObHocM8FPbjyaBg&usqp=CAU"
                    let url = URL(string: urlString)!
                    self.productImage.af.setImage(withURL: url)
                    self.businessId = firstInventoryItem["BusinessId"] as! String
                    self.calculatePrice()
                }
            }
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {
        quantity += 1
        calculatePrice()
    }
    
    @IBAction func decreaseQuantity(_ sender: Any) {
        if quantity > 0 {
            quantity -= 1
            calculatePrice()
        }
    }
    
    func calculatePrice(){
        newPrice = Double(priceGlobal)! * Double(quantity)
        let formattedPrice = String(format: "$%.2f", newPrice)
        priceLabel.text = formattedPrice
    }
    
    @IBAction func saveOrder(_ sender: Any) {
        if quantity > 0 {
            let order = PFObject(className: "Orders")
            order["businessId"] = businessId
            order["BusinessName"] = businessName.text
            order["description"] =  productDescription.text
            order["price"] = String(format: "%.2f", newPrice)
            order["inventoryID"] = currentItemId
            order["quantity"] = String(quantity)
            order["status"] = "Incomplete"
            order["customer"] = currentUser
            guard let imageData2 = productImage.image?.jpegData(compressionQuality: 0.5) else {
                return
            }
            let imageFile2 = PFFileObject(name: "image.jpg", data: imageData2)
            order["content"] = imageFile2
            
            order.saveInBackground()
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
}
