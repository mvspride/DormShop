//
//  ProfileCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/25/23.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
        
    @IBOutlet weak var profiledescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
