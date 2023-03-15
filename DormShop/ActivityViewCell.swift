//
//  ActivityViewCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/10/23.
//

import UIKit

class ActivityViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var profileView: UIButton!
    
    @IBAction func profileBttn(_ sender: UIButton) {
        print("profile yup")
    }
    
    @IBOutlet weak var postView: UIButton!
    
    @IBAction func postBttn(_ sender: UIButton) {
        print("post yup")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
