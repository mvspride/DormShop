//
//  CommentViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/22/23.
//

import UIKit
import Parse

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var commentTable: UITableView!
    
    @IBOutlet weak var addCommentField: UITextField!
    
    var currentPost: PFObject!
    var comments = [PFObject]()
    var currentUser = PFUser.current()

    
    //creates new comment and saves in data base
    @IBAction func postBttn(_ sender: UIButton) {
        let comment = PFObject(className: "Comments")
        comment["content"] = addCommentField.text
        comment["author"] = currentUser
        comment["post"] = currentPost
        currentPost!["numOfComments"] =  (currentPost["numOfComments"] as! Int) + 1
        comment.saveInBackground()
        addCommentField.text = ""
        //viewDidAppear(true)
        self.commentTable.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Comments")
        query.whereKey("post", contains: currentPost?.objectId)
        query.includeKey("author")
        query.findObjectsInBackground{(comments,error) in
            if comments != nil {
                self.comments = comments!
                self.commentTable.reloadData()

            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTable.delegate = self
        commentTable.dataSource = self

        
        let dismissKeyboardtapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(dismissKeyboardtapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }


@objc func keyboardWillShow(notification: NSNotification) {
    if let userInfo = notification.userInfo,
       let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {

        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -keyboardSize.height - 10
        }
    }
}

@objc func keyboardWillHide(notification: NSNotification) {
    UIView.animate(withDuration: 0.3) {
        self.view.frame.origin.y = 0
    }
}

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let currentComment = comments[indexPath.row] as PFObject
        cell.usernameLabel.text = currentUser?.username
        cell.commentTimeStamp.text = "2h"
        cell.commentContent.text = currentComment["content"] as? String
        print(currentComment["author"])
        var profileBttn =  cell.profileBttn
        //query the User to get the profile Image bc it is not accessible when you simply do "user["profileImg"]
        let query = PFQuery(className: "_User")
        query.getObjectInBackground(withId: (currentUser?.objectId)!) { (user: PFObject?, error: Error?) in
            if let user = user {
                let profileFile = user["profileImg"] as? PFFileObject
                print(profileFile)
                //gets the data of the parse file inorder to transform it into a UIImage
                profileFile!.getDataInBackground { (imageData: Data?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let imageData = imageData {
                        //gets UIImage and scales it to the size of the button
                        let image = UIImage(data: imageData)?.scaledToFit(profileBttn!.bounds.size)
                        //rounds profile button
                        profileBttn = profileBttn!.roundImage(profileBttn!)
                        cell.profileBttn.setImage(image, for: .normal)

                    }
                }
            } else {
                print("Error fetching user object: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        return cell
    }

    @objc func showKeyboard() {
        addCommentField.becomeFirstResponder()
        
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
