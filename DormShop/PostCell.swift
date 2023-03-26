//
//  PostCell.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/7/23.
//

import UIKit

protocol PostCellDelegate: AnyObject{
    func profileButton(with username: String, postIndex: Int)
    func likeButton(with username: String, postIndex: Int, likeButton: UIButton)
    func commentButton(with username: String, postIndex: Int)
    func replyButton(with username: String, postIndex: Int)

    
}
class PostCell: UITableViewCell {
    
    weak var delegate: PostCellDelegate?
  
    
    
    @IBAction func profileButton(_ sender: UIButton) {
        delegate?.profileButton(with: usernameLabel.text!, postIndex: postIndex)

    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        delegate?.likeButton(with: usernameLabel.text!, postIndex: postIndex, likeButton: likeButton)
//        if likeButton.tintColor == UIColor.red{
//            likeButton.tintColor = UIColor.white
//        }
//        else{
//            likeButton.tintColor = UIColor.red
//
//        }
    }
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var numOfLikes: UILabel!
    
    @IBAction func commentButton(_ sender: UIButton) {
        delegate?.commentButton(with: usernameLabel.text!, postIndex: postIndex)

    }
    
    @IBOutlet weak var numOfComments: UILabel!
    
    @IBAction func replyButton(_ sender: UIButton) {
        delegate?.replyButton(with: usernameLabel.text!, postIndex: postIndex)

    }
    
    @IBOutlet weak var contentUIView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    var postIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = true
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
