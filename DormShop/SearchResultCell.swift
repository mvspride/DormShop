//
//  SearchResultCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/7/23.
//

import UIKit

class SearchResultCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var BusinessName: UILabel!
    @IBOutlet weak var BusinessLocation: UILabel!
    @IBOutlet weak var BusinessRating: UILabel!
    
    @IBOutlet weak var inventoryCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inventoryCollectionView.dataSource = self
        inventoryCollectionView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryViewCell", for: indexPath) as! InventoryViewCell
        cell.inventoryPrice.text = "$5"
        cell.inventoryDscrp.text = "new lashes on sale"
        return cell
    }

}
