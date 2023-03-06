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
    
    @IBAction func searchButton(_ sender: UIButton) {
        
    }
    @IBOutlet var tableView: UITableView!
    
    var user = PFUser.current()
    var posts = [PFObject]()
    var businesses = [PFObject]()
    var selectedPost: PFObject!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKey("description")
        query.limit = 20
        query.findObjectsInBackground{(posts,error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
            // Do any additional setup after loading the view.
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //removes top bar. simulates tiktok
        //tableView?.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell

        let post = posts[indexPath.row]
        cell.captionLabel.text = post["description"] as? String
        print(post["description"])
        cell.postIndex = indexPath.row
        let imageFile = post["content"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.contentUIView.af.setImage(withURL: url)
        cell.delegate = self
        return cell
        
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
        let post = posts[postIndex]
        print(post["description"] as Any)
    }
    func likeButton(with username: String, postIndex: Int){
        let post = posts[postIndex]
        print(post["description"] as Any)

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


