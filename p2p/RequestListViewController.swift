//
//  RequestListViewController.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

struct RequestList {
    let bigId: String!
    let borrowerAmount: String!
    let borrowerId: String!
    let requestId: String!
    let status: Int!
}

class RequestListViewController: UIViewController {
    
    var inId = ""
    var arr = [RequestList]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "reusableCell")
        tableView.backgroundColor = .blueBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.allowsSelection = false
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        fetchRequests()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        
    }
    
    func fetchRequests(){
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("allRequests").queryOrdered(byChild: "borrowerId").queryEqual(toValue: uid).observe(.childAdded, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let bigId = value?["bigId"] as? String
            let borrowerAmount = value?["borrowerAmount"] as? String
            let borrowerId = value?["borrowerId"] as? String
            let requestId = value?["requestId"] as? String
            let status = value?["status"] as? Int
            
            self.arr.insert(RequestList(bigId: bigId, borrowerAmount: borrowerAmount, borrowerId: borrowerId, requestId: requestId, status: status), at: 0)
            
            self.tableView.reloadData()
        })
        
    }
    
    func setupView() {
        view.backgroundColor = .blueBackground
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        tableView <- [
            Width(Screen.width - 20),
            Bottom(0),
            Top(0),
            CenterX(0)
        ]
    }

    
}

extension RequestListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! BorrowTableViewCell
        cell.backgroundColor = .blueBackground
    
        
        User.fetchRequestId(requestId: arr[indexPath.row].requestId) { (name, rate, time) in
            
            
            User.fetchUserName(uid: name as! String, completion: { (name, surname, id) in
                cell.container.firstField.labelName.text = "\(name!) \(surname!)"
            })
            
            
            cell.container.secondField.labelName.text = "\(rate!) месяцев"
            cell.container.thirdField.labelName.text = "\(time!)"
        }
        

    
        cell.button.tag = indexPath.row
        return cell
    }
}
