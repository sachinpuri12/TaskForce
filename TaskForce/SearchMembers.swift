//
//  SearchMembers.swift
//  TaskForce
//
//  Created by Rexi Sheredy on 4/10/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchMembers: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var usernameArray = [String]()
    var keyArray = [String]()
    var db: FIRDatabaseReference!
    var filteredUsername = [String]()
    var filteredKey = [String]()
    var shouldShowResults = false
    var searchController: UISearchController!
    
    @IBOutlet var searchTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTable.delegate = self
        searchTable.dataSource = self
        configureSearchController()
        db = FIRDatabase.database().reference()
        getUsernamesKeys()
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchTable.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowResults = true
        searchTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowResults {
            shouldShowResults = true
            searchTable.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowResults = false
        searchTable.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController){
        filteredUsername.removeAll()
        filteredKey.removeAll()
        
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        for index in 0...usernameArray.count-1{
            let userText: NSString = usernameArray[index] as NSString
            if ((userText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound){
                filteredUsername.append(usernameArray[index])
                filteredKey.append(keyArray[index])
            }
        }
        // Reload the tableview.
        searchTable.reloadData()
    }
    
    func getUsernamesKeys(){
        let ref = FIRDatabase.database().reference(fromURL: "https://taskforce-ad0be.firebaseio.com/users")
        ref.queryOrderedByKey().observe(.childAdded, with: { snapshot in
    
            if let _ = snapshot.value as? NSNull {
                return
            } else {
                self.keyArray.append(snapshot.key)
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    if (rest.key == "username"){
                        self.usernameArray.append(rest.value as! String)
                    }
                }
                self.searchTable.reloadData()
            }
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTable.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowResults {
            return filteredUsername.count
        }
        else {
            return usernameArray.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = self.searchTable.dequeueReusableCell(withIdentifier: "SearchMemberCell", for: indexPath) as! SearchMemberCell
        
        if shouldShowResults {
            myCell.setInfo(name: filteredUsername[indexPath.row], key: filteredKey[indexPath.row], inGroup: false)
            myCell.setLabels()
        }
        else {
            myCell.setInfo(name: usernameArray[indexPath.row], key: keyArray[indexPath.row], inGroup: false)
            myCell.setLabels()
        }
        
        return myCell
    }
//
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
//
    
}
