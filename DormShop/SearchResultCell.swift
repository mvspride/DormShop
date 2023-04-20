//
//  SearchResultCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/7/23.
//

import UIKit
import Parse

class SearchResultCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var BusinessName: UILabel!
    @IBOutlet weak var BusinessLocation: UILabel!
    @IBOutlet weak var BusinessRating: UILabel!
    
    @IBOutlet weak var inventoryCollectionView: UICollectionView!
    
    var currInventory :[PFObject] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        inventoryCollectionView.dataSource = self
        inventoryCollectionView.delegate = self
        inventoryCollectionView.reloadData()

    }
    
    func configure(with currBusiness: PFObject ) {
        let businessId = currBusiness.objectId
        self.currInventory = queryInventory(businessId: businessId!)
        
     }
    
    func queryInventory(businessId: String) -> [PFObject] {
        
        let query = PFQuery(className: "Inventory")
        query.whereKey("BusinessId", equalTo: businessId)
        query.findObjectsInBackground{(inventory, error) in
            if inventory != nil {
                self.currInventory = inventory!
                self.inventoryCollectionView.reloadData()

            }
        }
        
        return self.currInventory
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currInventory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryViewCell", for: indexPath) as! InventoryViewCell
        let item = currInventory[indexPath.row]
        print("SearchResultCell------------------------------------")
        cell.inventoryPrice.text = item["price"] as? String
        cell.inventoryDscrp.text = item["description"] as? String
        let imageFile = item["content"] as? PFFileObject
        let urlString = imageFile?.url! ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQP7ARHenfnGXcxCIhmDxObHocM8FPbjyaBg&usqp=CAU"
        let url = URL(string: urlString)!
        cell.inventoryImgView.af.setImage(withURL: url)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(currInventory[indexPath.row])
    }

}
