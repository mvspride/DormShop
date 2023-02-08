//
//  FeedViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 2/7/23.
//

import UIKit
import Parse

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var numbers : [Int] = [2, 4, 6, 8]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = numbers[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
           
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")!
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        var keys: NSDictionary?

        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
               keys = NSDictionary(contentsOfFile: path)
           }
        if let dict = keys {
            let applicationId = dict["parseApplicationId"] as? String
            let clientKey = dict["parseClientKey"] as? String
            let server = "https://parseapi.back4app.com"
        }
        print(keys?["parseApplicationId"])
        

        // Do any additional setup after loading the view.
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
