//
//  ProfileCollectionViewCell.swift
//  DormShop
//
//  Created by Giovane Barnes on 4/11/23.
//

import UIKit


class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    
    @IBOutlet weak var cellDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set the text alignment to left
        cellDescription.textAlignment = .left
    }
    
}
