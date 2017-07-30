//
//  TakeBorrowViewController.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

class TakeBorrowViewController: UIViewController {
    
    var cell = 10

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 150
        return tableView
    }()
    
    var a = Container()
    
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
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(investorSearch), for: .touchUpInside)
        return button
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "10 подходящих вариантов"
        label.isHidden = true
        label.textColor = .white
        label.font = UIFont(name: "Helvetica", size: 20)
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.isHidden = true
        searchBar.barTintColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        searchBar.placeholder = "Введите имя"
        searchBar.layer.borderColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1).cgColor
        searchBar.layer.borderWidth = 1
        searchBar.tintColor = .white
        //        searchBar.
        searchBar.setValue("Отмена", forKey: "cancelButtonText")
        return searchBar
    }()
    
    let sizeX = UIScreen.main.bounds.width - 20
    let newSizeX = (UIScreen.main.bounds.width - 50)/2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blueBackground

        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.tableHeaderView = a
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: Int(sizeX), height: 260)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .blueBackground
        
        setupView()
        setupConstraints()
        
        fetchFromFirebase()
        
    }
//    
//    func pr() {
//     
//        print("Good and it works")
//        self.present(MenuMyDataViewController(), animated: true, completion: nil)
//        
//    }
    
    func fetchFromFirebase() {
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
    
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let balance = value?["balance"] as? Int
            let email = value?["email"] as? String
            let investor = value?["isInvestor"] as? Bool
            let password = value?["password"] as?  String
            let token = value?["token"] as? String
            let userData = value?["userData"] as? Bool
            
            
            
            
        }){ (error) in
            print(error.localizedDescription)
        }
    
    }
    
    func investorSearch() {
        searchBar.isHidden = false
        requestButton.isHidden = true
        investorSearchButton.isHidden = true
        print("Hello")
    }
    
    func pressed() {
        button.isHidden = true
        requestButton.isHidden = false
        investorSearchButton.isHidden = false
        label.isHidden = false
        
        let ref = Database.database().reference()
        let auth = Auth.auth().currentUser?.uid
        
        ref.child("users").child(auth!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            
            let isData = value?["userData"] as? Bool ?? false
            
            if isData {
                print("Good")
            } else {
                self.present(MenuMyDataViewController(), animated: true, completion: nil)
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
    }
    
    func setupView() {
        view.addSubview(tableView)
        a.addSubview(button)
        a.addSubview(requestButton)
        a.addSubview(investorSearchButton)
        a.addSubview(label)
        a.addSubview(searchBar)
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        
        tableView <- [
            Width(sizeX),
            Bottom(10),
            Top(0),
            CenterX(0)
        ]
        
        button <- [
            CenterX(0),
            //Top(25).to( container.field2, .bottom),
            Bottom(30),
            //Top(25).to(BorrowContainer().field2, .bottom),
            Width(180),
            Height(50)
        ]
        
        requestButton <- [
            Top(15).to(button, .top),
            Width(newSizeX),
            Height(50),
            Left(10)
        ]
        
        investorSearchButton <- [
            Top(15).to(button, .top),
            Width(newSizeX),
            Height(50),
            Right(10)
        ]
        
        label <- [
            CenterX(0),
            Bottom(0).to(button, .top),
            Height(25)
        ]
        
        searchBar <- [
            Top(15).to(button, .top),
            CenterX(0),
            Height(50),
            Width(sizeX-10)
        ]
        
    }

}


