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
    
    var groupKey: String = ""
    var userKey: String = ""
    var usernameArray = [String]()
    var keyArray = [String]()
    var inGroupArray = [Bool]()
    var db: FIRDatabaseReference!
    var filteredUsername = [String]()
    var filteredKey = [String]()
    var filteredInGroup = [Bool]()
    var shouldShowResults: Bool = false
    var searchController: UISearchController!
    var groupName: String = ""
    
    @IBOutlet var searchTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTable.delegate = self
        searchTable.dataSource = self
        configureSearchController()
        db = FIRDatabase.database().reference()
        getUsernamesKeys()
        userKey = (UserDefaults.standard.value(forKey: "user_id_taskforce")) as! String
        print(self.groupName)
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
        filteredInGroup.removeAll()
        
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        for index in 0...usernameArray.count-1{
            let userText: NSString = usernameArray[index] as NSString
            if ((userText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound){
                filteredUsername.append(usernameArray[index])
                filteredKey.append(keyArray[index])
                filteredInGroup.append(inGroupArray[index])
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
                var hasGroups = false
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    if (rest.key == "username"){
                        self.usernameArray.append(rest.value as! String)
                        print(rest.value!)
                    }
                    if (rest.key == "groups"){
                        hasGroups = true
                        let enumerator2 = rest.children
                        var inGroup = false
                        while let groups = enumerator2.nextObject() as? FIRDataSnapshot{
                            if(groups.key == self.groupKey){
                                inGroup = true
                            }
                        }
                        self.inGroupArray.append(inGroup)
                    }
                }
                if !hasGroups{
                    self.inGroupArray.append(false)
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
            myCell.setInfo(name: filteredUsername[indexPath.row], key: filteredKey[indexPath.row], groupKey: groupKey, inGroup: filteredInGroup[indexPath.row], groupName: self.groupName)
            myCell.setLabels()
        }
        else {
            myCell.setInfo(name: usernameArray[indexPath.row], key: keyArray[indexPath.row], groupKey: groupKey, inGroup: inGroupArray[indexPath.row], groupName: self.groupName)
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
