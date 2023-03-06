//
//  IconButton.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/5/23.
//

import Foundation
import UIKit

@IBDesignable
class IconButton: UIButton {
    @IBInspectable var pointSize:CGFloat = 40.0

    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: pointSize)
            setPreferredSymbolConfiguration(config, forImageIn: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
}
