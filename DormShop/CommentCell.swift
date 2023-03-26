//
//  CommentCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/22/23.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var profileBttn: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var commentTimeStamp: UILabel!
    
    @IBOutlet weak var commentContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
