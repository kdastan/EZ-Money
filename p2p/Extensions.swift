//
//  Extensions.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SwiftValidator



extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuReusableCell", for: indexPath) as! MenuSideTableViewCell
        cell.label.text = arr[indexPath.row]
        cell.iconImage.image = UIImage(named: "\(imgArr[indexPath.row])")
        return cell
    }
}


extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            
            self.present(MenuMyDataViewController(), animated: true, completion: nil)
            
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        case 4:
            self.signOut()
        default:
            print("Nothing")
        }
    }
}

extension TakeBorrowViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchBar.isHidden = true
        
        requestButton.isHidden = false
        investorSearchButton.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            filteredInvestorsList = investorsList
        } else {
            filteredInvestorsList = investorsList.filter {$0.nameForSearch.lowercased().contains((searchBar.text?.lowercased())!)}
        }
        self.tableView.reloadData()
    }
}



