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
    
    var a = Container()
    var arr: [BorrowTableViewCell] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 150
        tableView.tableHeaderView = self.a
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: Int(Screen.width - 20), height: 260)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .blueBackground
        tableView.dataSource = self
        return tableView
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
        searchBar.delegate = self
        searchBar.setValue("Отмена", forKey: "cancelButtonText")
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        fetchFromFirebase()
    }
    
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
        
            if !isData {
                self.present(MenuMyDataViewController(), animated: true, completion: nil)
            }
        }) {(error) in
            print(error.localizedDescription)
        }
        
        print(self.a.container.field.textField.text)
        print(self.a.container.field2.textField.text)
    }
    
    func setupView() {
        edgesForExtendedLayout = []
        view.backgroundColor = .blueBackground
        view.addSubview(tableView)
        [button, requestButton, investorSearchButton, label, searchBar].forEach {a.addSubview($0)}
    }
    
    func setupConstraints() {
        tableView <- [
            Width(Screen.width - 20),
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
            Width((Screen.width - 50)/2),
            Height(50),
            Left(10)
        ]
        
        investorSearchButton <- [
            Top(15).to(button, .top),
            Width((Screen.width - 50)/2),
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
            Width(Screen.width-30)
        ]
    }

}

extension TakeBorrowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BorrowTableViewCell
        cell.backgroundColor = .blueBackground
        cell.button.tag = indexPath.row
        return cell
    }
}


