import UIKit
import Parse

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var table: UITableView!
    
    var orders = [PFObject]()
    var currentUser =  MyClass.shared.getCurrentViewer()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        
        orderQuery()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        orderQuery()
        table.reloadData()
    }
    
    func orderQuery(){
        let query = PFQuery(className: "Orders")
        query.whereKey("customer", equalTo: currentUser as Any)
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.findObjectsInBackground { (orders, error) in
            if orders  != nil {
                self.orders = orders!
                self.table.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell") as! OrdersTableViewCell
        let order = orders[indexPath.row]
        
        cell.OrderInfo1.text = order["BusinessName"] as? String
        cell.OrderInfo2.text = order["description"] as? String
        if let price = order["price"] as? String {
            cell.OrderInfo3.text = "$\(price)"
        } else {
            cell.OrderInfo3.text = ""
        }
        cell.OrderInfo4.text = order["status"] as? String
        cell.OrderInfo5.text = order["quantity"] as? String
        let imageFile = order["content"] as? PFFileObject
        let urlString = imageFile?.url! ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQP7ARHenfnGXcxCIhmDxObHocM8FPbjyaBg&usqp=CAU"
        let url = URL(string: urlString)!
        cell.iconImageView.af.setImage(withURL: url)
        return cell
    }
}
