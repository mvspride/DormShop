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
    var spinner = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
  
    
    var user = PFUser.current()
    var currUser = MyClass.shared.getCurrentViewer()
    var postsToDisplay = [PFObject]()
    var businesses = [PFObject]()
    var currentPost: PFObject!
    var currentPostComments = [PFObject]()
    var currentPostLikes = 0
    var myPostsBttn = UIButton(type: .system)
    let followingBttn = UIButton(type: .system)
    let campusBttn = UIButton(type: .system)
    
    func setBussNavBarBttns(){
        followingBttn.setTitle("Following", for: .normal)
        followingBttn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        followingBttn.addTarget(self, action: #selector(queryFollowingPost), for: .touchUpInside)

        campusBttn.setTitle("Campus", for: .normal)
        campusBttn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        campusBttn.addTarget(self, action: #selector(queryCampusPost), for: .touchUpInside)
        
        myPostsBttn.setTitle("My Posts", for: .normal)
        myPostsBttn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        myPostsBttn.addTarget(self, action: #selector(queryMyPosts), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [followingBttn, campusBttn, myPostsBttn])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 30.0
        stackView.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        
        navigationItem.titleView = stackView
    }

    func setNavBarBttns(){
        followingBttn.setTitle("Following", for: .normal)
        followingBttn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        followingBttn.addTarget(self, action: #selector(queryFollowingPost), for: .touchUpInside)

        campusBttn.setTitle("Campus", for: .normal)
        campusBttn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        campusBttn.addTarget(self, action: #selector(queryCampusPost), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [followingBttn, campusBttn])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 30.0
        stackView.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
        
        navigationItem.titleView = stackView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Make the navigation bar translucent
        navigationController?.navigationBar.isTranslucent = true

        // Set the navigation bar background image to UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        // Hide the navigation bar's bottom border
        navigationController?.navigationBar.shadowImage = UIImage()
        //setNavBarBttns()
        //setBussNavBarBttns()
        spinnerF()
        
        refreshControl.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        refreshControl.tintColor = UIColor.red

        //display campus posts
        queryCampusPost()


    }
    @objc func refreshTableView(_ sender: AnyObject) {
         // Reload the table view data
         tableView.reloadData()

         // End the refreshing animation
         refreshControl.endRefreshing()
     }
    func spinnerF(){
        spinner.style = .large
        spinner.color = .gray
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        currUser = MyClass.shared.getCurrentViewer()
        if(MyClass.shared.isUser(currentViewer: currUser))
            {
            setNavBarBttns()
        }
        else{
            setBussNavBarBttns()
        }
        
    }
    
    @IBAction func queryCampusPost(){
        campusBttn.tintColor = UIColor.white
        followingBttn.tintColor = UIColor.gray
        myPostsBttn.tintColor = UIColor.gray

                let campusPostQuery = PFQuery(className: "Posts")
                campusPostQuery.addDescendingOrder("createdAt")
                campusPostQuery.findObjectsInBackground{(posts,error) in
                    if posts != nil {
                        self.postsToDisplay = posts!
                        self.tableView.reloadData()
                        self.spinner.stopAnimating()
                      
                    }
                }

    }
    
    @IBAction func queryFollowingPost(){
        followingBttn.tintColor = UIColor.white
        campusBttn.tintColor = UIColor.gray
        myPostsBttn.tintColor = UIColor.gray

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
            followingPostQuery.addDescendingOrder("createdAt")
            followingPostQuery.whereKey("BusinessId", containedIn: businessesFollowingIds)
            followingPostQuery.findObjectsInBackground{(posts,error) in
                if posts != nil {
                    self.postsToDisplay = posts!
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }

     
        
    }
    
    @IBAction func queryMyPosts(){
        myPostsBttn.tintColor = UIColor.white
        followingBttn.tintColor = UIColor.gray
        campusBttn.tintColor = UIColor.gray
        let myPostQuery = PFQuery(className: "Posts")
        myPostQuery.addDescendingOrder("createdAt")
        myPostQuery.whereKey("BusinessId", equalTo: currUser.objectId!)
        myPostQuery.findObjectsInBackground{(posts,error) in
            if posts != nil {
                self.postsToDisplay = posts!
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                print("doneee")
                print(posts)
                print(self.currUser.objectId)

              
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
        return postsToDisplay.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return tableView.frame.height
      }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
//        if postsToDisplay.count{
//            print("empty")
//        }
        let post = postsToDisplay[indexPath.row]
        
        cell.usernameLabel.text = post["BusinessName"] as? String
        cell.captionLabel.text = post["description"] as? String
        cell.postIndex = indexPath.row
        let numOfLikes = post["numOfLikes"] as? Int
        let numOfComments = post["numOfComments"] as? Int
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
        currentPost = postsToDisplay[postIndex]
        
        
    }
    func likeButton(with username: String, postIndex: Int,likeButton: UIButton){
        self.currentPost = postsToDisplay[postIndex]
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
        self.currentPost = postsToDisplay[postIndex]
        // triggers the segue to the Comment View Controller
        performSegue(withIdentifier: "toCommentVC", sender: self)

    }
    func replyButton(with username: String, postIndex: Int){
        self.currentPost = postsToDisplay[postIndex]
        print(currentPost["description"] as Any)

    }
    
}


