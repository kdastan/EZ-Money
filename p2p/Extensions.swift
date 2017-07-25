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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello"
        return cell
    }
    
}
