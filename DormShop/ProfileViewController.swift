
//  ProfileViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/7/23.
//

import UIKit
import Parse
class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var profileNameBttn: UIButton!
    
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var profileDesc: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var currentUser = MyClass.shared.getCurrentViewer()
    @IBOutlet weak var editProfileButton: UIButton!

    var inventories = [PFObject]()
    
    var currentItemId: String = ""
    var spinner = UIActivityIndicatorView()

    
    @IBOutlet weak var headerView: UIView!
    var headerHeight: CGFloat = 200 // Set the height of the header view
    
    
    @IBAction func switchBttn(_ sender: UIButton) {
           // Get a reference to the tab bar controller
           guard let tabBarController = self.tabBarController else { return }
           
           // Create a new view controller instance
           let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessInboxViewController")
           
           // Get the current list of view controllers and add the new one
           var viewControllers = tabBarController.viewControllers ?? []
           viewControllers.append(newViewController)
           
           // Set the modified list of view controllers back to the tab bar controller
           tabBarController.viewControllers = viewControllers
        
    }
    func spinnerF(){
        spinner.style = .large
        spinner.color = .gray
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        profileDesc.placeholder = "Description Goes Here..."
//        profileDesc.borderStyle = .roundedRect
        queryInventory()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.spinnerF()
        queryInventory()
        self.currentUser = MyClass.shared.getCurrentViewer()
        let username = currentUser["username"] as? String
        profileNameBttn.setTitle(username, for: .normal)
        
        if let description = currentUser["description"] as? String {
            profileDesc.text = description
            print(description)
        } else {
            print("Description not found or not a String")
        }
        let urlString = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQP7ARHenfnGXcxCIhmDxObHocM8FPbjyaBg&usqp=CAU"
        let url = URL(string: urlString)!
        profileImgView.af.setImage(withURL: url)
        
        self.spinner.stopAnimating()


    }
    
    func queryInventory(){
            let currentUser = MyClass.shared.getCurrentViewer()
            let inventoryQuery = PFQuery(className: "Inventory")
            inventoryQuery.addDescendingOrder("createdAt")
            inventoryQuery.whereKey("BusinessId", equalTo: currentUser.objectId)
            inventoryQuery.findObjectsInBackground{(inventory,error) in
                if inventory != nil {
                    self.inventories = inventory!
                    self.collectionView.reloadData()
                }
            }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return inventories.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryCell", for: indexPath) as! ProfileCollectionViewCell
            let inventory = inventories[indexPath.row]
            print(inventory)
            print("_____________________________________")
            let imageFile = inventory["content"] as? PFFileObject
            let urlString = imageFile?.url! ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQP7ARHenfnGXcxCIhmDxObHocM8FPbjyaBg&usqp=CAU"
            let url = URL(string: urlString)!
            cell.cellImage.af.setImage(withURL: url)
            cell.cellDescription.text = inventory["description"] as! String?
            cell.cellPrice.text = inventory["price"] as! String?
            // Set the image of the inventory item here
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width / 3.0 // Set the width to be one-third of the collection view's width
            let height = collectionView.frame.height // Set the height to be equal to the collection view's height
            return CGSize(width: width, height: height)
               
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle the selection of the cell at the given index path
        
        
        let selectedInventory = inventories[indexPath.row]
        
        currentItemId = selectedInventory.objectId!
        print("Profile View Controller - ItemId")
        print(currentItemId)
        // For example, you could perform a segue to a detail view controller passing the selected inventory object
        performSegue(withIdentifier: "showDetail", sender: selectedInventory)
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDetail"{
                
                let createOrderController = segue.destination as! CreateOrderViewController
                // createOrderController
                
                createOrderController.currentItemId = self.currentItemId
            }
            
        }

}
