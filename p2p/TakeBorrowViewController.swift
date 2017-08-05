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
import FirebaseDatabase
import NotificationBannerSwift
import SwipeViewController
import SCLAlertView

struct Requests {
    let amount: String!
    let date: String!
    let id: String!
    let investorId: String!
    let rate: String!
    let time: String!
}

struct Names {
    let name: String!
    let surname: String!
    let uid: String!
}

struct Investors {
    let amount: String!
    let date: String!
    let id: String!
    let investorId: String!
    let rate: String!
    let time: String!
    let name: String!
    let surname: String!
    let patronymic: String!
    let nameForSearch: String!
}

class TakeBorrowViewController: UIViewController {
    
    let banner = NotificationBanner(title: "Запрос успешно отправлен", subtitle: "", style: .success)
    
    var a = Container()
    var arr: [BorrowTableViewCell] = []
    
    var rqsts = [Requests]()
    var nms = [Names]()
    
    var investorsList: [Investors] = []
    var filteredInvestorsList: [Investors] = []
    
    var names: [[String]] = []
    
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
        label.text = "Все варианты"
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
        
        
    }
    
    func investorSearch() {
        searchBar.isHidden = false
        requestButton.isHidden = true
        investorSearchButton.isHidden = true
        print(rqsts.count)
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
        
        
        User.fetchInvestor(request: "investorRequests") { (amount, date, id, investorId, rate, time) in
            guard let investorId = investorId else {return}
            User.fetchUserName(uid: investorId, completion: { (name, surname, patronymic) in
                self.investorsList.insert(Investors(amount: amount, date: date, id: id, investorId: investorId, rate: rate, time: time, name: name, surname: surname, patronymic: patronymic, nameForSearch: "\(name) \(surname) \(patronymic)"), at: 0)
                self.filteredInvestorsList = self.investorsList
                self.tableView.reloadData()
            })
        }
    
    }
    
    func buttonPressed(sender: UIButton) {
        
        guard let amount = a.container.field.textField.text, a.container.field.textField.text != "", let uid = Auth.auth().currentUser?.uid else {
            print("fill data")
            return
        }
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!
            
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Подтверждаю", backgroundColor: .blue, textColor: .white, showDurationStatus: true) {
            
            let reference = Database.database().reference()
            let newRef = reference.child("allRequests").childByAutoId()
            let post: [String: Any] = [
                "bigId": newRef.key,
                "borrowerAmount": amount,
                "borrowerId": uid,
                "requestId": self.filteredInvestorsList[sender.tag].id,
                "status": 0
            ]
            self.banner.duration = 2
            self.banner.show()
            newRef.setValue(post)
        }
        alertView.showWarning("Отправить запрос?", subTitle: "\((filteredInvestorsList[sender.tag].name)!) на \((self.a.container.field.textField.text)!) Тенге,  \n на \((filteredInvestorsList[sender.tag].time)!) месяцев под \((filteredInvestorsList[sender.tag].rate)!) % годовых", closeButtonTitle: "Отменить", colorStyle: 0x4BA2D3, colorTextButton: 0xE3F2FC)
        
        //
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
            Bottom(30),
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

extension TakeBorrowViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchBar.isHidden = true
        
        print(self.names)
        
        requestButton.isHidden = false
        investorSearchButton.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            filteredInvestorsList = investorsList
        } else {
            filteredInvestorsList = investorsList.filter {$0.nameForSearch.lowercased().contains((searchBar.text?.lowercased())!)}
        }
        self.tableView.reloadData()
    }
    
}


extension TakeBorrowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.label.text = "Найдено \(filteredInvestorsList.count) инвесторов"
        return filteredInvestorsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BorrowTableViewCell
        cell.backgroundColor = .blueBackground
        
        let name = filteredInvestorsList[indexPath.row].name
        let surname = filteredInvestorsList[indexPath.row].surname
        let patronymic = filteredInvestorsList[indexPath.row].patronymic
        let time = filteredInvestorsList[indexPath.row].time
        
        cell.container.firstField.labelName.text = "\(surname!) \(name!) \(patronymic!)"
        cell.container.secondField.labelName.text = "\(time!) месяцев"
        cell.container.thirdField.labelName.text = filteredInvestorsList[indexPath.row].rate
        
        //print(investorsList[indexPath.row].time)
        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
}


