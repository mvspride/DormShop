//
//  MenuCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/12/23.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuIcon: UIImageView!
    
    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
