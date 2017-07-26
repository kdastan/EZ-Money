//
//  Extensions.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit

extension TakeBorrowViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BorrowTableViewCell
        cell.backgroundColor = .blueBackground
        cell.button.tag = indexPath.row
        return cell
    }
    
    
}

extension RequestListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! BorrowTableViewCell
        cell.backgroundColor = .blueBackground
        cell.button.tag = indexPath.row
        return cell
    }
    
}

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
