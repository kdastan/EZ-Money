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
import SVProgressHUD

class MenuViewController: UIViewController {
    
    //MARK: Properties
    let arr = ["Мои данные", "Баланс", "История запросов", "Настройка аккаунта", "Выйти"]
    let imgArr = ["user", "wallet", "file", "settings", "logout"]
    
    var isInvestor: Bool?
    var headerView = MenuHeaderView()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.register(MenuSideTableViewCell.self, forCellReuseIdentifier: "menuReusableCell")
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = self.headerView
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            fetchFromDB()
    }
    
    //MARK: Views configuration
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        edgesForExtendedLayout = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        isInvestor = appDelegate.isInvestor
    }
    
    //MARK: Constraints configuration
    func setupConstraints() {
        tableView <- [
            Width(UIScreen.main.bounds.width),
            Height(358),
            CenterY(0),
            Left(0)
        ]
    }
    
    //MARK: Fetch - Username data - Need to divide to model
    func fetchFromDB() {
        SVProgressHUD.show()
        let ref = Database.database().reference()
        let currentID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(currentID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.headerView.email.text = value?["email"] as? String ?? "no email"
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("userData").child(currentID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //self.nameInfoLabel.text = value?["name"] as? String ?? "Name Surname"
            var name = value?["name"] as? String ?? "Name Surname"
            let surname = value?["surname"] as? String ?? "Name Surname"
            let newName = (name.characters.first)!
            self.headerView.nameInfoLabel.text = "\(surname) \(newName)."
            SVProgressHUD.dismiss()
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: Sign out implementation
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

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuReusableCell", for: indexPath) as! MenuSideTableViewCell
        cell.label.text = arr[indexPath.row]
        cell.iconImage.image = UIImage(named: "\(imgArr[indexPath.row])")
        return cell
    }
}

