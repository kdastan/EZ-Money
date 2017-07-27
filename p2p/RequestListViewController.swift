//
//  RequestListViewController.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class RequestListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "reusableCell")
        tableView.backgroundColor = .blueBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.allowsSelection = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blueBackground
        
        tableView.dataSource = self
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        tableView <- [
            Width(UIScreen.main.bounds.width-20),
            Bottom(0),
            Top(0),
            Left(10),
            CenterX(0)
        ]
    }

    
}


