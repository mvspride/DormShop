//
//  ProfileItemsCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/25/23.
//

import UIKit

class ProfileItemsCell: UITableViewCell {

    @IBOutlet weak var itemImg: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
