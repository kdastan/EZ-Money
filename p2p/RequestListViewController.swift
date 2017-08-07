//
//  RequestListViewController.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import DGElasticPullToRefresh

struct RequestsLists {
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
}

struct RequestsInvestor {
    let name: String!
    let surname: String!
    let patronymic: String!
    let status: Int!
    let rate: String!
    let time: String!
}

class RequestListViewController: UIViewController {
    
    var isInvestor: Bool?
    
    var requestList = [RequestsLists]()
    var investorRequsest = [RequestsInvestor]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "reusableCell")
        tableView.backgroundColor = .blueBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.allowsSelection = false
        tableView.dataSource = self
        return tableView
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.addTarget(self, action: #selector(update), for: .touchUpInside)
        return button
    }()
    
    func update() {
        self.requestList.removeAll()
        self.fetchRequestList()
        //fetchForInvestorList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        isInvestor = appDelegate.isInvestor
        setupView()
        setupConstraints()
        fetchRequestList()
        
        fetchForInvestorList()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.tableView.reloadData()
//    }
    
    func setupView() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.requestList.removeAll()
            //self?.fetchRequestList()
            //self?.tableView.reloadData()
            self?.fetchRequestList()
            self?.tableView.dg_stopLoading()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        view.backgroundColor = .blueBackground
        view.addSubview(tableView)
        view.addSubview(button)
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        tableView <- [
            Width(Screen.width - 20),
            Bottom(0),
            Top(0),
            CenterX(0)
        ]
        
        button <- [
            Width(Screen.width),
            Height(44),
            Bottom(0),
            CenterX(0)
        ]
    }
    
    func fetchRequestList(){
        self.tableView.reloadData()
        User.fetchRequests(fetchChild: "allRequests") { (bigId, borrowerAmount, borrowerId, requestId, status) in
            User.fetchRequestId(requestId: requestId!, completion: { (investorId, rate, time) in
                User.fetchUserName(uid: investorId!, completion: { (name, surname, patronymic) in
                    self.requestList.insert(RequestsLists(bigId: bigId, borrowerAmount: borrowerAmount, borrowerId: borrowerId, requestId: requestId, status: status, investorId: investorId, rate: rate, time: time, name: name, surname: surname, patronymic: patronymic), at: 0)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func fetchForInvestorList(){
        
        User.fetchRequestID(fetchChild: "investorRequests") { (id, rate, time) in
            User.fetchAllRequests(fetchChild: id!, completion: { (borrowerId, status) in
                User.fetchUserName(uid: borrowerId!, completion: { (name, surname, patronymic) in
                    self.investorRequsest.insert(RequestsInvestor(name: name, surname: surname, patronymic: patronymic, status: status, rate: rate, time: time), at: 0)
                    self.tableView.reloadData()
                })
            })
        }
    }
}

extension RequestListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isInvestor! {
            return investorRequsest.count
        } else {
            return requestList.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! BorrowTableViewCell
        cell.backgroundColor = .blueBackground
        
        if isInvestor! {
            cell.button.isHidden = true
            
            cell.container.firstField.labelName.text = investorRequsest[indexPath.row].name
            cell.container.secondField.labelName.text = investorRequsest[indexPath.row].time
            cell.container.thirdField.labelName.text = investorRequsest[indexPath.row].rate
            
            cell.investorButtonAccept.tag = indexPath.row
            cell.investorButtonDecline.tag = indexPath.row
            
        } else {
            cell.investorButtonAccept.isHidden = true
            cell.investorButtonDecline.isHidden = true
            
            let name = requestList[indexPath.row].name
            let surname = requestList[indexPath.row].surname
            let patronymic = requestList[indexPath.row].patronymic
            
//            guard let name = requestList[indexPath.row].name, let surname = requestList[indexPath.row].surname, let patronymic = requestList[indexPath.row].patronymic else {
//                return
//            }
            
            cell.container.firstField.labelName.text = "\(name!) \(surname!) \(patronymic!)"
            cell.container.secondField.labelName.text = "\(requestList[indexPath.row].time!) месяца"
            cell.container.thirdField.labelName.text = requestList[indexPath.row].rate
            if requestList[indexPath.row].status == 0 {
                cell.button.setTitle("В ожидании", for: .normal)
            } else if requestList[indexPath.row].status == 1 {
                cell.button.setTitle("Принят", for: .normal)
            } else if requestList[indexPath.row].status == 2 {
                cell.button.setTitle("Оформлен", for: .normal)
            } else if requestList[indexPath.row].status == 3 {
                cell.button.setTitle("Отклонен", for: .normal)
            }

        }
        
        
        return cell
    }
}
