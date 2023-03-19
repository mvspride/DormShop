//
//  OrdersTableViewCell.swift
//  DormShop
//
//  Created by Giovane Barnes on 3/19/23.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var OrderInfo1: UILabel!
    
    @IBOutlet weak var OrderInfo2: UILabel!
    
    @IBOutlet weak var OrderInfo3: UILabel!
}
