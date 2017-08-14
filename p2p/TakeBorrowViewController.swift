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
import SCLAlertView
import Alamofire
import SwiftValidator
import SVProgressHUD

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
    let token: String!
}

class TakeBorrowViewController: UIViewController {
    
    let banner = NotificationBanner(title: "Запрос успешно отправлен", subtitle: "", style: .success)
    let warningBanner = NotificationBanner(title: "Заполните все поля", subtitle: nil, style: .warning)
    
    var a = Container()
    var arr: [BorrowTableViewCell] = []
    
    var rqsts = [Requests]()
    var nms = [Names]()
    
    var investorsList: [Investors] = []
    var filteredInvestorsList: [Investors] = []
    var queryMessage = ""
    
    var names: [[String]] = []
    let validator = Validator()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 180
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
        button.setTitle("Получить займ", for: .normal)
        button.isHidden = true
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
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
        textFieldValidation()
        
    }
    
    func notificationSender(investorToken: String) {
//        let ref = Database.database().reference()
        let notificationUrl = "https://fcm.googleapis.com/fcm/send"
        let serverKey = "AAAAiyp0u8w:APA91bEuiQ--qrKwl_ahYWvr0qbs30gN55XT-U5XNq2ptO_pznUyjSaYXwEFz1SK1pKyxcBIE7Y9ALxLj5gXjNCioqzre7jSNA8gG0Xu_YskTsX5HS1s6I527FXcc8lFz6dgF892jhr8"
        
        let token = investorToken
        
        var header: HTTPHeaders? = HTTPHeaders()
        header = [
            "Content-Type":"application/json",
            "Authorization":"key=\(serverKey)"
        ]
        var notificationParameters: Parameters? = [
            "notification": [
                "title": "Запрос на деньги",
                "body": self.queryMessage
            ],
            "to" : "\(token)"
        ]
        
        Alamofire.request(notificationUrl as URLConvertible, method: .post as HTTPMethod, parameters: notificationParameters, encoding: JSONEncoding.default, headers: header!).responseJSON { (resp) in
            print(resp)
        }
    }
    
    func notificationToUser(sender: UIButton) {
    }
    
    func investorSearch() {
        searchBar.isHidden = false
        requestButton.isHidden = true
        investorSearchButton.isHidden = true
        print(rqsts.count)
    }
    
    func pressed() {
        
        validator.validate(self)
    
    }
    
    func textFieldValidation() {
        validator.styleTransformers(success:{ (validationRule) -> Void in
            //            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
                
            }
        }, error:{ (validationError) -> Void in
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
        validator.registerField(a.container.field.textField, errorLabel: nil, rules: [NumbersValidation()])
        validator.registerField(a.container.field2.textField, errorLabel: nil, rules: [NumbersValidation()])
    }
    
    
    func buttonPressed(sender: UIButton) {
        print("asdadsasdad")
        guard let amount = a.container.field.textField.text, a.container.field.textField.text != "", let uid = Auth.auth().currentUser?.uid else {
            print("fill data")
            return
        }
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Подтверждаю") {
            
            let reference = Database.database().reference()
            let newRef = reference.child("allRequests").childByAutoId()
            let notificationRecord = reference.child("notifications").childByAutoId()
            
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
            
            let investorId = self.filteredInvestorsList[sender.tag].id
            let investorToken = self.filteredInvestorsList[sender.tag].token
            
            
            User.fetchUserEmail(uid: uid, compleation: { (email, token) in
                self.queryMessage = "\(email!) запрашивает у вас деньги"
                var post = [
                    "from":uid,
                    "message": self.queryMessage,
                    "to":investorId!
                ]
                
                notificationRecord.setValue(post)
                
            })
            print(investorToken)
            self.notificationSender(investorToken: investorToken!)
            
        }
        alertView.showWarning("Отправить запрос?", subTitle: "\((filteredInvestorsList[sender.tag].name)!) на \((self.a.container.field.textField.text)!) Тенге,  \n на \((filteredInvestorsList[sender.tag].time)!) месяцев под \((filteredInvestorsList[sender.tag].rate)!) % годовых", closeButtonTitle: "Отменить", colorStyle: 0x4BA2D3, colorTextButton: 0xE3F2FC)
        
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

extension TakeBorrowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.label.text = "Найдено \(filteredInvestorsList.count) инвесторов"
        return filteredInvestorsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BorrowTableViewCell
        cell.backgroundColor = .blueBackground
        
        cell.label.isHidden = true
        cell.investorButtonAccept.isHidden = true
        cell.investorButtonDecline.isHidden = true
        cell.investorIssue.isHidden = true
       
        let name = filteredInvestorsList[indexPath.row].name
        let surname = filteredInvestorsList[indexPath.row].surname
        let patronymic = filteredInvestorsList[indexPath.row].patronymic
        let time = filteredInvestorsList[indexPath.row].time
        
        cell.container.firstField.labelName.text = "\(surname!) \(name!) \(patronymic!)"
        cell.container.secondField.labelName.text = "\(time!) месяцев"
        cell.container.thirdField.labelName.text = filteredInvestorsList[indexPath.row].rate
        cell.container.fourthField.labelName.text = filteredInvestorsList[indexPath.row].amount
        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
}

extension TakeBorrowViewController: ValidationDelegate {
    func validationSuccessful() {
        SVProgressHUD.show()
        
        tableView.reloadData()
        
        guard let moneyAmount = a.container.field.textField.text, a.container.field.textField.text != "", let time = a.container.field2.textField.text, a.container.field2.textField.text != "" else {
            return
        }
        
        button.isHidden = true
        requestButton.isHidden = false
        investorSearchButton.isHidden = false
        label.isHidden = false
        
        let ref = Database.database().reference()
        let auth = Auth.auth().currentUser?.uid
        ref.child("users").child(auth!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let isData = value?["userData"] as? Bool ?? false
            SVProgressHUD.dismiss()
            if !isData {
                self.present(MenuMyDataViewController(), animated: true, completion: nil)
            }
        }) {(error) in
            SVProgressHUD.dismiss()
            print(error.localizedDescription)
        }
        investorsList.removeAll()
        SVProgressHUD.show()
        User.fetchInvestor(request: "investorRequests") { (amount, date, id, investorId, rate, time) in
            guard let investorId = investorId else {return}
            User.fetchUserName(uid: investorId, completion: { (name, surname, patronymic) in
                User.fetchUserEmail(uid: investorId, compleation: { (email, token) in
                    self.investorsList.insert(Investors(amount: amount, date: date, id: id, investorId: investorId, rate: rate, time: time, name: name, surname: surname, patronymic: patronymic, nameForSearch: "\(name) \(surname) \(patronymic)", token: token), at: 0)
                    SVProgressHUD.dismiss()
                    self.filteredInvestorsList = self.investorsList
                    self.tableView.reloadData()
                })
            })
        }
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        warningBanner.duration = 1
        warningBanner.show()
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
}
