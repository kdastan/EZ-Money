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
    
    let sizeX = UIScreen.main.bounds.width

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuReusableCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
            Size(sizeX),
            CenterY(0),
            Left(0)
        ]
    }

}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuReusableCell", for: indexPath)
        cell.textLabel?.text = "Smth"
        return cell
    }

}
