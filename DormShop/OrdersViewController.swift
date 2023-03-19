//
//  OrdersViewController.swift
//  DormShop
//
//  Created by Giovane Barnes on 3/19/23.
//

import UIKit
import Parse

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var table: UITableView!
    
    var orders = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Orders")
        
       // query.whereKey("customer", equalTo: )
        query.limit = 20
        
        query.findObjectsInBackground { (orders, error) in
            if orders  != nil {
                self.orders = orders!
                self.table.reloadData()
            }
            
            
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return orders.count
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell") as! OrdersTableViewCell
        
        
        cell.OrderInfo1.text = "Will work"
        
        cell.OrderInfo2.text = "Maybe Not"
        
        return cell
    }
//
//    /*
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */

}
