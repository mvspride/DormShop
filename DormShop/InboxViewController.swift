//
//  InboxViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/7/23.
//

import UIKit
import Parse

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //var currentViewer = MyClass.shared.getCurrentViewer()
    var userPosts = [PFObject]()
    var postsLikes = [PFObject]()
    var postsComments = [PFObject]()
    
    @IBOutlet weak var inboxTableView: UITableView!
    

    let sectionTitles = ["Orders","comments","likes" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        inboxTableView.delegate = self
        inboxTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.currentViewer = MyClass.shared.getCurrentViewer()
        queryAllPosts()
        queryLikes()
        queryComments()
        self.inboxTableView.reloadData()

    }
//    let query = PFQuery(className: "Likes")
//    let now = Date()
//    let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: now)!
//    query.whereKey("createdAt", greaterThanOrEqualTo: oneWeekAgo)
//    query.findObjectsInBackground { (likes, error) in
//        if let error = error {
//            print("Error fetching likes: \(error.localizedDescription)")
//        } else if let likes = likes {
//            print("Likes from the past week: \(likes)")
//        }
//    }
    func queryAllPosts(){
        let query = PFQuery(className: "Posts")
        //query.whereKey("BusinessId", equalTo: currentViewer.objectId!)
        query.findObjectsInBackground{(posts,error) in
            if posts != nil {

            }
        }
    }
    func queryLikes(){
        let query = PFQuery(className: "Likes")
        query.whereKey("post", containedIn: userPosts)
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground{(likes,error) in
            if likes != nil {
                self.postsLikes = likes!
                self.inboxTableView.reloadData()
            }
        }
    }
    func queryComments(){
        let query = PFQuery(className: "Comments")
        query.whereKey("post", containedIn: userPosts)
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground{(comments,error) in
            if comments != nil {
                self.postsComments = comments!
                self.inboxTableView.reloadData()
            }
            else{
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return postsLikes.count
        case 1:
            return postsComments.count
        case 2:
            return postsLikes.count
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
//
//        // Button1
//        let button1 = UIButton(frame: CGRect(x: 15.0, y: 0, width: 100, height: 28.0))
//        button1.setTitle("Button 1", for: .normal)
//        button1.addTarget(self, action: #selector(selectorButton1), for: .touchUpInside)
//
//        // Button2
//        let button2 = UIButton(frame: CGRect(x: tableView.frame.width-150, y: 0, width: 150, height: 30.0))
//        button2.setTitle("Button2", for: .normal)
//        button2.addTarget(self, action: #selector(selectorButton2), for: .touchUpInside)
//        button2.semanticContentAttribute = UIApplication.shared
//            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
//
//        headerView.addSubview(button1)
//        headerView.addSubview(button2)
//        return headerView
//    }
//
//
//        @objc func selectorButton1(_ sender : Any) {
//
//        }
//
//        @objc func selectorButton2(_ sender : Any) {
//
//        }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
          return sectionTitles[section]
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityViewCell") as! ActivityViewCell
        var temp = "hey"
        switch indexPath.section {
                case 0:
                    let order = postsLikes[indexPath.row]
                    temp = "order"
            print(order["customer"])
            print("answer")
                case 1:
                    let comment = postsComments[indexPath.row]
                    temp = "comment"
                case 2:
                    let like = postsLikes[indexPath.row]
                    temp = "like"
                default:
                    break
                }
        activityCell.username.text = temp
                return activityCell
//        if indexPath.row < 1{
//            //show activity
//            let activityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityViewCell") as! ActivityViewCell
//            let like = postsLikes[indexPath.row]
//            //let comment = postsComments[indexPath.row]
//            let postView = activityCell.postView
//            let postImage = UIImage(named: "plane")?.scaledToFit(postView!.bounds.size)
//            postView?.setImage(postImage, for: .normal)
//
//            var profileView = activityCell.profileView
//            let profileImage = UIImage(named: "plane")?.scaledToFit(postView!.bounds.size)
//            profileView?.setImage(profileImage, for: .normal)
//            profileView = profileView?.roundImage(profileView!)
//
//        activityCell.username.text = "hey"
//            return activityCell
//
//        }
//        else{
//            //show messages
//            let cell = tableView.dequeueReusableCell(withIdentifier: "InboxViewCell") as! InboxViewCell
//            let profileBttn = cell.profileBttn
//            let image = UIImage(named: "plane")
//            let scaledImage = image?.scaledToFit(profileBttn!.bounds.size)
//            profileBttn!.setImage(scaledImage, for: .normal)
//            //profileBttn?.setImage(UIImage(named: "plane"), for: .normal)
//            profileBttn?.layer.cornerRadius = (profileBttn?.frame.height)! / 2
//            profileBttn?.layer.masksToBounds = true
//
//
//            return cell
//        }
//
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
extension UIImage {
    func scaledToFit(_ size: CGSize) -> UIImage? {
        let aspectRatio = self.size.width / self.size.height
        let targetAspectRatio = size.width / size.height
        var scaledSize = size
        if aspectRatio > targetAspectRatio {
            scaledSize.width = size.height * aspectRatio
        } else {
            scaledSize.height = size.width / aspectRatio
        }
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        return scaledImage
    }
    
}
extension UIButton {
    func roundImage(_ button: UIButton) -> UIButton{
        button.layer.cornerRadius = (button.frame.height) / 2
        button.layer.masksToBounds = true
        return button
    }
}
