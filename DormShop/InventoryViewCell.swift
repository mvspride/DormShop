//
//  InventoryViewCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 4/10/23.
//

import UIKit

class InventoryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var inventoryImgView: UIImageView!
    
    @IBOutlet weak var inventoryDscrp: UILabel!
    
    @IBOutlet weak var inventoryPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
