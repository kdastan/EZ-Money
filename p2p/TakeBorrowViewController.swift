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
    
    var cell = 0

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    let sizeX = UIScreen.main.bounds.width - 20
    let newSizeX = (UIScreen.main.bounds.width - 50)/2
    
    lazy var container: BorrowContainer = {
        let container = BorrowContainer()
        container.backgroundColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        container.layer.cornerRadius = 4
        return container
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Получить займ", for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var requestButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Запросить всех", for: .normal)
        button.isHidden = true
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var investorSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Найти инвестора", for: .normal)
        button.isHidden = true
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    func pressed() {
        button.isHidden = true
        requestButton.isHidden = false
        investorSearchButton.isHidden = false
        cell = 5
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView.dataSource = self
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(container)
        container.addSubview(button)
        view.addSubview(tableView)
        view.addSubview(requestButton)
        view.addSubview(requestButton)
        view.addSubview(investorSearchButton)
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        container <- [
            Width(sizeX),
            Height(250),
            Top(10),
            CenterX(0)
        ]
        
        button <- [
            CenterX(0),
            Top(25).to(container.field2, .bottom),
            Width(180),
            Height(50)
        ]
        
        requestButton <- [
            Top(0).to(button, .top),
            Width(newSizeX),
            Height(50),
            Left(20)
        ]
        
        investorSearchButton <- [
            Top(0).to(button, .top),
            Width(newSizeX),
            Height(50),
            Right(20)
        ]
        
        tableView <- [
            Width(sizeX),
            Bottom(10),
            Top(10).to(container, .bottom),
            CenterX(0)
        ]
        
    }

}


