//
//  SearchResultCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/7/23.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet var inventoryScrollView: UIScrollView!
    
    
    @IBOutlet weak var BusinessName: UILabel!
    @IBOutlet weak var BusinessLocation: UILabel!
    @IBOutlet weak var BusinessRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
