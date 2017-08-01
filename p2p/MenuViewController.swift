//
//  MenuViewController.swift
//  p2p
//
//  Created by Apple on 26.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

class MenuViewController: UIViewController {
    
    let arr = ["Мои данные", "Пополнить баланс", "История запросов", "Настройка аккаунта", "Выйти"]
    let imgArr = ["user", "wallet", "file", "settings", "logout"]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.register(MenuSideTableViewCell.self, forCellReuseIdentifier: "menuReusableCell")
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = MenuHeaderView()
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: Int(Screen.width), height: 58)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        edgesForExtendedLayout = []
    }
    
    func setupConstraints() {
        tableView <- [
            Width(UIScreen.main.bounds.width),
            Height(358),
            CenterY(0),
            Left(0)
        ]
    }
    
    func signOut() {
        let auth = Auth.auth()
        do {
            try auth.signOut()
        } catch let error {
            print (error.localizedDescription)
        }
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.isLogged = false
        appDelegate.cordinateAppFlow()
    }
    
}


