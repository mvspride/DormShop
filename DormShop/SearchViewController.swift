//
//  SearchViewController.swift
//  DormShop
//
//  Created by Pride Mbabit on 3/6/23.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField!

    @IBAction func searchBttn(_ sender: UIButton) {
        searchField.resignFirstResponder()
    }
    @IBOutlet var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        // Set the view controller as the delegate of the search text field
        searchField.delegate = self
        let dismissKeyboardtapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(dismissKeyboardtapGesture)
    }
   //dismiss keyboard when user clicks "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchField.resignFirstResponder()
            return true
        }
    //dismiss keyboard when user clicks anywhere on screen
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! SearchResultCell

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
