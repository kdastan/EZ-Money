//
//  TakeBorrowViewController.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class TakeBorrowViewController: UIViewController {
    
    var cell = 10

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 150
        return tableView
    }()
    
    let sizeX = UIScreen.main.bounds.width - 20
    let newSizeX = (UIScreen.main.bounds.width - 50)/2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blueBackground

        tableView.dataSource = self
        
        tableView.tableHeaderView = Container()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: Int(sizeX), height: 260)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .blueBackground
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        
        tableView <- [
            Width(sizeX),
            Bottom(10),
            Top(0),
            CenterX(0)
        ]
        
    }

}


