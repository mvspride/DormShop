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
    var posts = [PFObject]()
    var businesses = [PFObject]()
    var selectedPost: PFObject!
    var numOflikes = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let postQuery = PFQuery(className: "Posts")
        postQuery.includeKey("description")
        postQuery.includeKey("author")
        postQuery.findObjectsInBackground{(posts,error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                
            }
            // Do any additional setup after loading the view.
        }
        let likesQuery = PFQuery(className: "Likes")
        likesQuery.findObjectsInBackground{(likes,error) in
            if likes != nil {
                self.numOflikes = likes?.count ?? 0
                
            }
            // Do any additional setup after loading the view.
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
//
//        tableView.rowHeight = UIScreen.main.bounds.height - tabBarHeight - 33

        // Do any additional setup after loading the view.
        let business = PFObject(className: "Business")

        let post1 = PFObject(className:"Posts")
        post1["description"] = "1st post"
        post1["author"] = business
        
        let post2 = PFObject(className:"Posts")
        post2["description"] = "2nd post"
        post2["author"] = business
        
        business["owner"] = PFUser.current()
        business["username"] = "new Buss"
        
        post1.saveInBackground()
        post2.saveInBackground()
        business.saveInBackground()

    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        if let author = post.object(forKey: "author") as? PFObject {
            let authorName = author.object(forKey: "username") as? String ?? "Unknown"
            cell.usernameLabel.text = authorName
            
        }
        cell.numOfLikes.text = String(self.numOflikes)
        cell.captionLabel.text = post["description"] as? String
        cell.postIndex = indexPath.row
        let imageFile = post["content"] as? PFFileObject
        let urlString = imageFile?.url! ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQP7ARHenfnGXcxCIhmDxObHocM8FPbjyaBg&usqp=CAU"
        let url = URL(string: urlString)!
        cell.contentUIView.af.setImage(withURL: url)
        cell.delegate = self
        return cell
        
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return tableView.frame.height
       }
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func commentView(){
        
    }

}
extension FeedViewController: PostCellDelegate{
    func profileButton(with username: String, postIndex: Int){
        let post = posts[postIndex]
        
        
    }
    func likeButton(with username: String, postIndex: Int){
        let post = posts[postIndex]
        let like = PFObject(className: "Likes")
        let query = PFQuery(className: "Likes")
        query.whereKey("post", contains: post.objectId)
        query.whereKey("user", contains: PFUser.current()?.objectId)
        query.findObjectsInBackground { (likes: [PFObject]?, error: Error?) in
            if error == nil {
                // Loop through the objects and delete them
                if likes!.isEmpty{
                    like["post"] = post
                    like["user"] = PFUser.current()
                    like.saveInBackground()
                }
                else{
                    likes?[0].deleteInBackground()
                }
                
            } else {
                print("Error: \(error!) \(error!.localizedDescription)")
            }
        }
        
        
        
    }
    func commentButton(with username: String, postIndex: Int){
        let post = posts[postIndex]
        
        print(post["description"] as Any)

    }
    func replyButton(with username: String, postIndex: Int){
        let post = posts[postIndex]
        print(post["description"] as Any)

    }
    
}


