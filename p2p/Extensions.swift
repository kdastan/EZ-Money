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
