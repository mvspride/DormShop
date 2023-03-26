//
//  FeedViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/7/23.
//

import UIKit
import Parse
import AlamofireImage
import AVKit
import AVFAudio


class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var user = PFUser.current()
    var campusPosts = [PFObject]()
    var followingPosts = [PFObject]()
    var businesses = [PFObject]()
    var currentPost: PFObject!
    var currentPostComments = [PFObject]()
    var currentPostLikes = 0
    @IBOutlet weak var followingBtn: UIButton!
    
    @IBOutlet weak var campusBtnn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //display campus posts
        queryCampusPost()
        //set "Following" bttn to gray
        followingBtn.tintColor = UIColor.gray
        


    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //set navBar to invisible so that posts reaches the very top of the screen view
        self.navigationController?.navigationBar.isHidden = true
        

        
    }
    @IBAction func queryCampusPost(){
        campusBtnn.tintColor = UIColor.white
        followingBtn.tintColor = UIColor.gray
                let campusPostQuery = PFQuery(className: "Posts")
                campusPostQuery.addAscendingOrder("createdAt")
                campusPostQuery.findObjectsInBackground{(posts,error) in
                    if posts != nil {
                        self.campusPosts = posts!
                        self.tableView.reloadData()
                    }
                }
    

        
    }
    @IBAction func queryFollowingPost(){
        campusBtnn.tintColor = UIColor.gray
        followingBtn.tintColor = UIColor.white
        var businessesFollowingIds = [String]()
        let userFollowingsQuery = PFQuery(className: "Following")
        userFollowingsQuery.whereKey("userId", contains: user?.objectId)
        userFollowingsQuery.findObjectsInBackground{(followings,error) in
            if followings != nil {
                for following in followings!{
                    let businessId = following["businessId"] as? String
                    businessesFollowingIds.append(businessId!)
                }
                
            }
            let followingPostQuery = PFQuery(className: "Posts")
            followingPostQuery.addAscendingOrder("createdAt")
            followingPostQuery.whereKey("BusinessId", containedIn: businessesFollowingIds)
            followingPostQuery.findObjectsInBackground{(posts,error) in
                if posts != nil {
                    self.campusPosts = posts!
                    print(posts)
                    self.tableView.reloadData()
                }
            }
        }

     
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCommentVC" {
            let destinationVC = segue.destination as! CommentViewController
            destinationVC.currentPost = self.currentPost
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campusPosts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return tableView.frame.height
      }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = campusPosts[indexPath.row]

        
        cell.usernameLabel.text = post["BusinessName"] as? String
        cell.captionLabel.text = post["description"] as? String
        cell.postIndex = indexPath.row
        var numOfLikes = post["numOfLikes"] as? Int
        var numOfComments = post["numOfComments"] as? Int
        cell.numOfLikes.text = String(numOfLikes!)
        cell.numOfComments.text = String(numOfComments!)
        let imageFile = post["content"] as? PFFileObject
        let urlString = imageFile?.url! ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQP7ARHenfnGXcxCIhmDxObHocM8FPbjyaBg&usqp=CAU"
        let url = URL(string: urlString)!
        cell.contentUIView.af.setImage(withURL: url)
        cell.delegate = self
        
        return cell
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: tableView.contentOffset, size: tableView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let visibleIndexPath = tableView.indexPathForRow(at: visiblePoint) {
            // Determine which cell is currently visible
            let visibleCell = tableView.cellForRow(at: visibleIndexPath)
            // Do something with the visible cell

        }
    }

    func commentsQuery(currentPost: PFObject) -> Int{
        let commentsQuery = PFQuery(className: "Comments")
        commentsQuery.whereKey("post", contains: currentPost.objectId)
        commentsQuery.findObjectsInBackground { (comments: [PFObject]?, error: Error?) in
            if error == nil {
                self.currentPostComments = comments!
            } else {
                print("Error: \(error!) \(error!.localizedDescription)")
            }
            
        }
        return currentPostComments.count
    }
   
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FeedViewController: PostCellDelegate{
    func profileButton(with username: String, postIndex: Int){
        currentPost = campusPosts[postIndex]
        
        
    }
    func likeButton(with username: String, postIndex: Int,likeButton: UIButton){
        self.currentPost = campusPosts[postIndex]
        let like = PFObject(className: "Likes")
        let query = PFQuery(className: "Likes")
        query.whereKey("post", contains: currentPost.objectId)
        query.whereKey("user", contains: PFUser.current()?.objectId)
        query.findObjectsInBackground { (likes: [PFObject]?, error: Error?) in
            if error == nil {
                if likes!.isEmpty{
                    like["post"] = self.currentPost
                    like["user"] = PFUser.current()
                    self.currentPost["numOfLikes"] = 1 + (self.currentPost["numOfLikes"] as! Int)
                    self.currentPost.saveInBackground()
                    like.saveInBackground()
                    self.tableView.reloadData()

                    likeButton.tintColor = UIColor.red
                    
                }
                else{
                    likes?[0].deleteInBackground { (success: Bool, error: Error?) in
                              if let error = error {
                                  // Handle any errors that occurred while deleting
                                  print("Error deleting object: \(error.localizedDescription)")
                              } else {
                                  // Object was deleted successfully
                                  print("Object deleted")
                                  self.currentPost["numOfLikes"] = (self.currentPost["numOfLikes"] as! Int) - 1
                                  self.currentPost.saveInBackground()
                                  self.tableView.reloadData()
                                  likeButton.tintColor = UIColor.white
                              }
                          }
                    
                }
                
            } else {
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
        
    
    }
    func commentButton(with username: String, postIndex: Int){
        self.currentPost = campusPosts[postIndex]
        

        // triggers the segue to the Comment View Controller
        performSegue(withIdentifier: "toCommentVC", sender: self)

    }
    func replyButton(with username: String, postIndex: Int){
        self.currentPost = campusPosts[postIndex]
        print(currentPost["description"] as Any)

    }
    
}


