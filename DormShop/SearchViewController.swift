//
//  SearchViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/6/23.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    var user = PFUser.current()
    var businesses = [PFObject]()
    var filteredBusinesses = [PFObject]()
    
    
    
    @IBOutlet weak var searchField: UITextField!

    @IBAction func searchBttn(_ sender: UIButton) {
        searchField.resignFirstResponder()
    }
    @IBOutlet var searchResultTableView: UITableView!
    

    @IBAction func searchTextChangedd(_ sender: Any) {
        if searchField.text?.isEmpty == true {
                filteredBusinesses = businesses
            } else {
                filteredBusinesses = businesses.filter { business in
                    guard let username = business["username"] as? String else {
                        return false
                    }
                    return username.contains(searchField.text ?? "")
                }
            }
            searchResultTableView.reloadData()
    }
    

   //dismiss keyboard when user clicks "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchField.resignFirstResponder()
            return true
        }
    //dismiss keyboard when user clicks anywhere on screen
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        // Set the view controller as the delegate of the search text field
        searchField.delegate = self
        let dismissKeyboardtapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(dismissKeyboardtapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let BusinessQuery = PFQuery(className: "Business")
        BusinessQuery.whereKey("username", contains: searchField.text ?? "")
        BusinessQuery.findObjectsInBackground{(businesses,error) in
            if businesses != nil {
                self.businesses = businesses!
                self.filteredBusinesses = self.businesses // set the filtered businesses to be the same as the initial businesses
                self.searchResultTableView.reloadData()
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
        
        let business = filteredBusinesses[indexPath.row]
        cell.BusinessName.text = business["username"] as? String
        cell.BusinessLocation.text = business["location"] as? String
        cell.BusinessRating.text = business["Rating"] as? String
        
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
