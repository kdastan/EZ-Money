//
//  ArchiveViewController.swift
//  p2p
//
//  Created by Apple on 11.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import SVProgressHUD

struct RequestList {
    let name: String!
    let surname: String!
    let patronymic: String!
    let status: Int!
    let rate: String!
    let time: String!
    let requestId: String!
    let nameForSearch: String!
}

struct InvestorsList {
    let bigId: String!
    let borrowerAmount: String!
    let borrowerId: String!
    let requestId: String!
    let status: Int!
    let investorId: String!
    let rate: String!
    let time: String!
    let name: String!
    let surname: String!
    let patronymic: String!
    let nameForSearch: String!
}

class ArchiveViewController: UIViewController {
    
    var requestList: [RequestList] = []
    var filteredRequestList: [RequestList] = []
    
    var investorList: [InvestorsList] = []
    var filteredInvestorsList: [InvestorsList] = []
    
    var isInvestor: Bool?
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .blueBackground
        searchBar.placeholder = "Поиск"
        searchBar.layer.borderColor = UIColor(colorLiteralRed: 227/255, green: 242/255, blue: 253/255, alpha: 1).cgColor
        searchBar.layer.borderWidth = 1
        searchBar.tintColor = .white
        searchBar.delegate = self
        searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchBar.showsScopeBar = true
        //searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .selected)
        //searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .normal)
        searchBar.scopeButtonTitles = ["Все", "Оформлен", "Отклонен"]
        
        return searchBar
    }()
    
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blueBackground
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = 150
        tableView.dataSource = self
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "reusableCell")
        return tableView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(colorLiteralRed: 213/255, green: 70/255, blue: 70/255, alpha: 1)
        button.setTitle("Назад", for: .normal)
        button.addTarget(self, action: #selector(backPressed(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetch()
    }
    
    func setupViews() {
        view.backgroundColor = .blueBackground
        view.addSubview(button)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        isInvestor = appDelegate.isInvestor
    }
    
    func setupConstraints() {
        
        button <- [
            Bottom(0),
            CenterX(0),
            Width(Screen.width),
            Height(44)
        ]
        
        tableView <- [
            Top(104),
            CenterX(0),
            Width(Screen.width - 20),
            Bottom(44)
        ]
        
        searchBar <- [
            Top(20),
            CenterX(0),
            Height(84),
            Width(Screen.width)
        ]
    }
    
    func backPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetch() {
        
        SVProgressHUD.show()
        
        if isInvestor! {
        User.fetchRequestID(fetchChild: "investorRequests") { (id, rate, time) in
            User.fetchAllRequests(fetchChild: id!, completion: { (borrowerId, status, requestId) in
                User.fetchUserName(uid: borrowerId!, completion: { (name, surname, patronymic) in
                    self.requestList.insert(RequestList(name: name, surname: surname, patronymic: patronymic, status: status, rate: rate, time: time, requestId: requestId, nameForSearch: "\(name) \(surname) \(patronymic)"), at: 0)
                    self.filteredRequestList = self.requestList
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                })
            })
        }
            
        } else {
        //User
            User.fetchRequests(fetchChild: "allRequests") { (bigId, borrowerAmount, borrowerId, requestId, status) in
                User.fetchRequestId(requestId: requestId!, completion: { (investorId, rate, time) in
                    User.fetchUserName(uid: investorId!, completion: { (name, surname, patronymic) in
                        self.investorList.insert(InvestorsList(bigId: bigId, borrowerAmount: borrowerAmount, borrowerId: borrowerId, requestId: requestId, status: status, investorId: investorId, rate: rate, time: time, name: name, surname: surname, patronymic: patronymic, nameForSearch: "\(name) \(surname) \(patronymic)"), at: 0)
                        self.filteredInvestorsList = self.investorList
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    })
                })
            }
        }
    }
    //Investor
    func filterList(index: Int) {
        filteredRequestList = requestList
        filteredRequestList = filteredRequestList.filter {$0.status == index}
    }
    //User
    func filterInvestor(index: Int) {
        filteredInvestorsList = investorList
        filteredInvestorsList = filteredInvestorsList.filter {$0.status == index}
    }

}
extension ArchiveViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInvestor! {
            return filteredRequestList.count
        } else {
            return filteredInvestorsList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! BorrowTableViewCell
        cell.backgroundColor = .blueBackground
        
        cell.button.isHidden = true
        cell.investorButtonAccept.isHidden = true
        cell.investorButtonDecline.isHidden = true
        cell.investorIssue.isHidden = true
        
        if isInvestor! {
            let name = filteredRequestList[indexPath.row].name
            let surname = filteredRequestList[indexPath.row].surname
            let patronymic = filteredRequestList[indexPath.row].patronymic
        
            
            if filteredRequestList[indexPath.row].status == 1 {
                cell.label.text = "Принят"
                cell.label.backgroundColor = .issuedColor
            } else if filteredRequestList[indexPath.row].status == 2 {
                cell.label.text = "Оформлен"
                cell.label.backgroundColor = .accepteColor
            
            } else if filteredRequestList[indexPath.row].status == 3 {
                cell.label.text = "Отклонен"
                cell.label.backgroundColor = .declineColor
            }
        
            cell.container.firstField.labelName.text = "\(name!) \(surname!) \(patronymic!)"
            cell.container.secondField.labelName.text = "\(filteredRequestList[indexPath.row].time!) месяца"
            cell.container.thirdField.labelName.text = filteredRequestList[indexPath.row].rate
        } else {
            let name = filteredInvestorsList[indexPath.row].name
            let surname = filteredInvestorsList[indexPath.row].surname
            let patronymic = filteredInvestorsList[indexPath.row].patronymic
            
            if filteredInvestorsList[indexPath.row].status == 1 {
                cell.label.text = "Принят"
                cell.label.backgroundColor = .issuedColor
            } else if filteredInvestorsList[indexPath.row].status == 2 {
                cell.label.text = "Оформлен"
                cell.label.backgroundColor = .accepteColor
                
            } else if filteredInvestorsList[indexPath.row].status == 3 {
                cell.label.text = "Отклонен"
                cell.label.backgroundColor = .declineColor
            }
            
            cell.container.firstField.labelName.text = "\(name!) \(surname!) \(patronymic!)"
            cell.container.secondField.labelName.text = "\(filteredInvestorsList[indexPath.row].time!) месяца"
            cell.container.thirdField.labelName.text = filteredInvestorsList[indexPath.row].rate
        }
        return cell
    }
}

extension ArchiveViewController: UISearchBarDelegate {
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
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if isInvestor! {
            switch selectedScope {
            case 0:
                filteredRequestList = requestList
            case 1:
                filterList(index: 2)
            case 2:
                filterList(index: 3)
            default:
                print("0")
            }
        } else {
            switch selectedScope {
            case 0:
                filteredInvestorsList = investorList
            case 1:
                filterInvestor(index: 2)
            case 2:
                filterInvestor(index: 3)
            default:
                print("0")
            }
        }
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if isInvestor! {
            if searchBar.text == "" {
            filteredRequestList = requestList
            } else {
                filteredRequestList = requestList.filter {$0.nameForSearch.lowercased().contains((searchBar.text?.lowercased())!)}
            }
        } else {
            if searchBar.text == "" {
                filteredInvestorsList = investorList
            } else {
                filteredInvestorsList = investorList.filter {$0.nameForSearch.lowercased().contains((searchBar.text?.lowercased())!)}
            }
        }
        self.tableView.reloadData()
    }
}





