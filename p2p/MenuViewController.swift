//
//  MenuViewController.swift
//  p2p
//
//  Created by Apple on 26.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class MenuViewController: UIViewController {
    
    let arr = ["Мои данные", "Пополнить баланс", "История запросов", "Настройка аккаунта", "Выйти"]
    let imgArr = ["user", "wallet", "file", "settings", "logout"] 

    let sizeX = UIScreen.main.bounds.width
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.register(MenuSideTableViewCell.self, forCellReuseIdentifier: "menuReusableCell")
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.tableHeaderView = MenuHeaderView()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: Int(sizeX), height: 58)
        
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
            Width(UIScreen.main.bounds.width),
            Height(358),
            CenterY(0),
            Left(0)
        ]
    }

}


