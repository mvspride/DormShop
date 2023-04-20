//
//  SearchViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/6/23.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    var user = PFUser.current()
    var businesses = [PFObject]()
    var filteredBusinesses = [PFObject]()
    var  tags = [String]()
    
    var currentItemId: String = ""
    
    
    @IBOutlet weak var searchField: UITextField!

    @IBAction func cancelBttn(_ sender: UIButton) {
        searchField.resignFirstResponder()
        filteredBusinesses = businesses
        searchResultTableView.reloadData()
    }
    
    @IBOutlet weak var categoryView: UICollectionView!
    
    @IBOutlet var searchResultTableView: UITableView!
    
    @IBOutlet weak var inventoryCollectionView: UICollectionView!
    
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
    
    func loadTags(){
        let tagQuery = PFQuery(className: "Category")
        tagQuery.addDescendingOrder("timesUsed")
        tagQuery.findObjectsInBackground{(tags,error) in
            if tags != nil {
                
                for tag in tags ?? []{
                    self.tags.append(tag["tagName"] as! String)
                }
                self.categoryView.reloadData()
            }
        }
    }
    func getBusinessWithTag(tagName: String){
        let query = PFQuery(className: "Account_tag")
        query.whereKey("category", equalTo: tagName)
        query.findObjectsInBackground{(result,error) in
            if result != nil {
                self.filteredBusinesses.removeAll()
                var businesIds = [String]()
                for tag in result ?? []{
                    let businessId = tag["businessId"] as! String
                    businesIds.append(businessId)
                    
                }
                self.getBusinessWithIds(businessIds: businesIds)
            }
            
        }
    }
    func getBusinessWithIds(businessIds: [String]) {
        let query = PFQuery(className: "Business")
        query.whereKey("objectId", containedIn: businessIds)
        query.findObjectsInBackground{(result,error) in
            if result != nil {
                self.filteredBusinesses = result!
                self.searchResultTableView.reloadData()
            }
            
        }
    }
    
    func loadBusinesses(){
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self

        categoryView.delegate = self
        categoryView.dataSource = self
       
        searchField.delegate = self
        
        loadTags()
        loadBusinesses()
        MyClass.shared.filteredBusinesses = businesses
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let category = PFObject(className: "Account_tag")
//        category.setValue("photographer", forKey: "category")
//        category.setObject(self.businesses[0], forKey: "business")
//        category.setValue(self.businesses[0].objectId, forKey: "businessId")
//        category.saveInBackground()
    
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return tags.count
        }
        
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
         cell.categoryName.text = self.tags[indexPath.row]
         let categoryImg = cell.categoryImg.image = UIImage(named: "plane")
        //cell.backgroundColor = UIColor.blue
         
            
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tagName = self.tags[indexPath.row]
        getBusinessWithTag(tagName: tagName)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell
        let business = filteredBusinesses[indexPath.row]
        cell.configure(with: business, viewController: self)
        cell.awakeFromNib()
        cell.BusinessName.text = business["username"] as? String
        cell.BusinessLocation.text = business["location"] as? String
        cell.BusinessRating.text = business["Rating"] as? String
        
        cell.didSelectItem = { [weak self] itemId in
            guard let self = self else { return }
            // Handle the selected item id here...
            print("Selected ItemId: \(itemId)")
            self.currentItemId = itemId
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filteredBusinesses[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popOver"{

            let createOrderController = segue.destination as! CreateOrderViewController
            // createOrderController
            print("Search Result Controller - ItemId")
            print(currentItemId)

            createOrderController.currentItemId = self.currentItemId
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
