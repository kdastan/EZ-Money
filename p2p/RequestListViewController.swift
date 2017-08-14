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
import SVProgressHUD
import NotificationBannerSwift
import Alamofire

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
    let requestId: String!
    let borrowerAmount: String!
    let borrowerId: String!
}

class RequestListViewController: UIViewController {
    
    var isInvestor: Bool?
    let banner = NotificationBanner(title: "Ваш список запросов пуст", subtitle: nil, style: .warning)
    let notEnoughMoney = NotificationBanner(title: "Не достаточно средств", subtitle: "Пополните кошелек", style: .warning)
    let successTransaction = NotificationBanner(title: "Инвестирование прошло успешно", subtitle: nil, style: .success)
    
    var investorsMoney: Int?
    
    var queryMessage = "Вам поступили деньги от инвестора"
    
    var requestList = [RequestsLists]()
    var investorRequsest = [RequestsInvestor]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "reusableCell")
        tableView.backgroundColor = .blueBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = 185
        tableView.allowsSelection = false
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        isInvestor = appDelegate.isInvestor
        setupView()
        setupConstraints()
        
        if isInvestor! {
            fetchForInvestorList()
            fetchForInvestorsAmount()
        } else {
            fetchRequestList()
        }
        
        
    }
    
    func fetchForInvestorsAmount() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        User.fetchForInvestorsAmount(uid: uid) { (balance) in
            self.investorsMoney = balance
            print("\(self.investorsMoney!) - Investors balance")
        }
    }
    
    func setupView() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            if (self?.isInvestor!)! {
                self?.investorRequsest.removeAll()
                self?.fetchForInvestorList()
            } else {
                self?.requestList.removeAll()
                self?.fetchRequestList()
            }
            
            
//            self?.requestList.removeAll()
//            //self?.investorRequsest.removeAll()
//            
//            //self?.fetchForInvestorList()
//            self?.fetchRequestList()
            
            self?.tableView.dg_stopLoading()
            
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        view.backgroundColor = .blueBackground
        view.addSubview(tableView)
        
        banner.duration = 1
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        tableView <- [
            Width(Screen.width - 20),
            Height(Screen.height - 64),
            Top(0),
            CenterX(0)
        ]
    }
    
    
  
    //MARK: Fetch for user
    func fetchRequestList(){
        self.tableView.reloadData()
        SVProgressHUD.show()
        
        User.fetchInvestorExisting(uid: "asd") { (result) in
        guard let _ = result else {
            SVProgressHUD.dismiss()
            self.banner.show()
            return
        }
            
        User.fetchRequests(fetchChild: "allRequests") { (bigId, borrowerAmount, borrowerId, requestId, status) in
            
            if borrowerId == nil {
                SVProgressHUD.dismiss()
                self.banner.show()
                return
            }
            
            User.fetchRequestId(requestId: requestId!, completion: { (investorId, rate, time) in
                User.fetchUserName(uid: investorId!, completion: { (name, surname, patronymic) in
                    self.requestList.insert(RequestsLists(bigId: bigId, borrowerAmount: borrowerAmount, borrowerId: borrowerId, requestId: requestId, status: status, investorId: investorId, rate: rate, time: time, name: name, surname: surname, patronymic: patronymic), at: 0)
                    self.tableView.reloadData()
                            SVProgressHUD.dismiss()
                    })
                })
            }
        }
    }
    //MARK: Fetch for Investor
    func fetchForInvestorList(){
        SVProgressHUD.show()
        self.tableView.reloadData()
        
        User.fetchAllRequestExisting(uid: "asd") { (result) in
            guard let _ = result else {
                SVProgressHUD.dismiss()
                self.banner.show()
                return
            }
        User.fetchRequestID(fetchChild: "investorRequests") { (id, rate, time) in
            if id == nil {
                SVProgressHUD.dismiss()
                self.banner.show()
                return
            }
            User.fetchAllRequests(fetchChild: id!, completion: { (borrowerId, status, requestId, borrowerAmount) in
                User.fetchUserName(uid: borrowerId!, completion: { (name, surname, patronymic) in
                    self.investorRequsest.insert(RequestsInvestor(name: name, surname: surname, patronymic: patronymic, status: status, rate: rate, time: time, requestId: requestId, borrowerAmount: borrowerAmount, borrowerId: borrowerId), at: 0)
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                })
            })
        }
        }
    }
    
    func accepted(sender: UIButton) {
        let requestID = (investorRequsest[sender.tag].requestId)!
        User.setRequestStatus(requestId: requestID, status: 1) { (finished) in
        }
        self.investorRequsest.removeAll()
        self.fetchForInvestorList()
    }
    func declined(sender: UIButton) {
        let requestID = (investorRequsest[sender.tag].requestId)!
        User.setRequestStatus(requestId: requestID, status: 3) { (finished) in
        }
        self.investorRequsest.removeAll()
        self.fetchForInvestorList()
    }

    func issueAS(sender: UIButton) {
        SVProgressHUD.show()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let requestID = (investorRequsest[sender.tag].requestId)!
        let borrowerBalance = Int(investorRequsest[sender.tag].borrowerAmount)
        let borrowerId = investorRequsest[sender.tag].borrowerId
        
        if investorsMoney! < borrowerBalance! {
            notEnoughMoney.duration = 1
            notEnoughMoney.show()
            SVProgressHUD.dismiss()
            return
        }
        
        investorsMoney = investorsMoney! - borrowerBalance!
        User.borrowerBalance(uid: borrowerId!) { (borrowerAmount, borrowerToken) in
            let newBalance = Int(borrowerAmount!) + borrowerBalance!
            User.successTransactionForBorrower(amount: newBalance, uid: borrowerId!, compleation: { (result) in
                print(borrowerToken!)
                SVProgressHUD.dismiss()
                
                
                
                self.notificationSender(investorToken: borrowerToken!)
            })
        }
        User.successTransactionForInvestor(amount: investorsMoney!, uid: uid) { (result) in
            self.successTransaction.duration = 1
            self.successTransaction.show()
        }
        
        User.setRequestStatus(requestId: requestID, status: 2) { (finished) in
        }
        
        
        self.investorRequsest.removeAll()
        self.fetchForInvestorList()
    }
    
    func notificationSender(investorToken: String) {
        //        let ref = Database.database().reference()
        let notificationUrl = "https://fcm.googleapis.com/fcm/send"
        let serverKey = "AAAAiyp0u8w:APA91bEuiQ--qrKwl_ahYWvr0qbs30gN55XT-U5XNq2ptO_pznUyjSaYXwEFz1SK1pKyxcBIE7Y9ALxLj5gXjNCioqzre7jSNA8gG0Xu_YskTsX5HS1s6I527FXcc8lFz6dgF892jhr8"
        
        let token = investorToken
        print(token)
        print("asdadasdasdsadassada")
        
        var header: HTTPHeaders? = HTTPHeaders()
        header = [
            "Content-Type":"application/json",
            "Authorization":"key=\(serverKey)"
        ]
        var notificationParameter: Parameters? = [
            "notification": [
                "title": "Проверьте кошелек",
                "body": self.queryMessage
            ],
            "to" : "\(token)"
        ]
        
        Alamofire.request(notificationUrl as URLConvertible, method: .post as HTTPMethod, parameters: notificationParameter, encoding: JSONEncoding.default, headers: header!).responseJSON { (resp) in
            print(resp)
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
            cell.label.isHidden = true
            cell.investorButtonAccept.isHidden = true
            cell.investorButtonDecline.isHidden = true
            cell.investorIssue.isHidden = true
            
            print(investorRequsest[indexPath.row].status)
            
            cell.investorButtonAccept.tag = indexPath.row
            cell.investorButtonDecline.tag = indexPath.row
            cell.investorIssue.tag = indexPath.row
            
            let name = investorRequsest[indexPath.row].name
            let surname = investorRequsest[indexPath.row].surname
            let patronymic = investorRequsest[indexPath.row].patronymic
            
            cell.container.firstField.labelName.text = "\(name!) \(surname!) \(patronymic!)"
            cell.container.secondField.labelName.text = "\(investorRequsest[indexPath.row].time!) месяца"
            cell.container.thirdField.labelName.text = investorRequsest[indexPath.row].rate
            cell.container.fourthField.labelName.text = "\(investorRequsest[indexPath.row].borrowerAmount!) Тенге"
            
            if investorRequsest[indexPath.row].status == 0 {
                cell.investorButtonAccept.isHidden = false
                cell.investorButtonDecline.isHidden = false
                
                cell.investorButtonAccept.addTarget(self, action: #selector(accepted(sender:)), for: .touchUpInside)
                cell.investorButtonDecline.addTarget(self, action: #selector(declined(sender:)), for: .touchUpInside)
                
            } else if investorRequsest[indexPath.row].status == 1 {
                cell.investorIssue.isHidden = false
                cell.investorIssue.addTarget(self, action: #selector(issueAS(sender:)), for: .touchUpInside)
                
            } else if investorRequsest[indexPath.row].status == 2 {
                cell.label.isHidden = false
                cell.label.text = "Оформлен"
                cell.label.backgroundColor = .accepteColor
    
            } else if investorRequsest[indexPath.row].status == 3 {
                cell.label.isHidden = false
                cell.label.text = "Отклонен"
                cell.label.backgroundColor = .declineColor
            }
            
        } else {
            cell.button.isHidden = true
            cell.investorButtonAccept.isHidden = true
            cell.investorButtonDecline.isHidden = true
            cell.investorIssue.isHidden = true
            
            let name = requestList[indexPath.row].name
            let surname = requestList[indexPath.row].surname
            let patronymic = requestList[indexPath.row].patronymic
            
            cell.container.firstField.labelName.text = "\(name!) \(surname!) \(patronymic!)"
            cell.container.secondField.labelName.text = "\(requestList[indexPath.row].time!) месяца"
            cell.container.thirdField.labelName.text = requestList[indexPath.row].rate
            cell.container.fourthField.labelName.text = "\(requestList[indexPath.row].borrowerAmount!) Тенге"
            
            if requestList[indexPath.row].status == 0 {
                cell.label.text = "В ожидании"
                cell.label.backgroundColor = .blueBackground
            } else if requestList[indexPath.row].status == 1 {
                cell.label.text = "Принят"
                cell.label.backgroundColor = .accepteColor
            } else if requestList[indexPath.row].status == 2 {
                cell.label.text = "Оформлен"
                cell.label.backgroundColor = .issuedColor
            } else if requestList[indexPath.row].status == 3 {
                cell.label.text = "Отклонен"
                cell.label.backgroundColor = .declineColor
            }
        }
        
        return cell
    }
}
