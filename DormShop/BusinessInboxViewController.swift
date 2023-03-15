//
//  BusinessInboxViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/13/23.
//

import UIKit

class BusinessInboxViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet weak var inboxTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inboxTableView.dataSource = self
        inboxTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 3{
            //show activity
            let activityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityViewCell") as! ActivityViewCell
            let postView = activityCell.postView
            let postImage = UIImage(named: "plane")?.scaledToFit(postView!.bounds.size)
            postView?.setImage(postImage, for: .normal)

            var profileView = activityCell.profileView
            let profileImage = UIImage(named: "plane")?.scaledToFit(postView!.bounds.size)
            profileView?.setImage(profileImage, for: .normal)
            profileView = profileView?.roundImage(profileView!)
            print("other one------------------------------")

            return activityCell

        }
        else{
            print("hell0-----------------------------------------")
            let cell = tableView.dequeueReusableCell(withIdentifier: "InboxViewCell") as! InboxViewCell
            let profileBttn = cell.profileBttn
            let image = UIImage(named: "plane")
            let scaledImage = image?.scaledToFit(profileBttn!.bounds.size)
            profileBttn!.setImage(scaledImage, for: .normal)
            //profileBttn?.setImage(UIImage(named: "plane"), for: .normal)
            profileBttn?.layer.cornerRadius = (profileBttn?.frame.height)! / 2
            profileBttn?.layer.masksToBounds = true
            
            return cell
        }
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
