//
//  WalletViewController.swift
//  p2p
//
//  Created by Apple on 09.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import SVProgressHUD
import SCLAlertView
import NotificationBannerSwift

class WalletViewController: UIViewController {
    
    let successBanner = NotificationBanner(title: "Кошелек успешно пополнен", subtitle: "", style: .success)
    let errorBanner = NotificationBanner(title: "Возникла ошибка", subtitle: "Попробуйте повторить позже", style: .warning)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пополнение кошелька"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 24)
        return label
    }()

    lazy var userInfoLabel: WalletAcountInfo = {
        let label = WalletAcountInfo()
        label.nameLabel.text = "Инвестор: "
        label.emailLabel.text = "Email: "
        label.balanceLabel.text = "Текущий баланс: "
        return label
    }()
    
    lazy var userRefillView: WalletRefill = {
        let refillView = WalletRefill()
        return refillView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(colorLiteralRed: 213/255, green: 70/255, blue: 70/255, alpha: 1)
        button.setTitle("Назад", for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        button.setTitle("Пополнить", for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(submitButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchUserInfo()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(userInfoLabel)
        view.addSubview(userRefillView)
        view.addSubview(titleLabel)
        view.addSubview(cancelButton)
        view.addSubview(submitButton)
    }
    
    func setupConstraints() {
        titleLabel <- [
            Top(44),
            CenterX(0),
            Width(Screen.width - 50)
        ]
        
        userInfoLabel <- [
            Top(22).to(titleLabel, .bottom),
            CenterX(0),
            Width(Screen.width - 40),
            Height(100)
        ]
        
        userRefillView <- [
            Top(0).to(userInfoLabel, .bottom),
            CenterX(0),
            Width(Screen.width - 20),
            Height(160)
        ]
        
        submitButton <- [
            Top(15).to(userRefillView, .bottom),
            CenterX(0),
            Width(Screen.width - 40),
            Height(44)
        ]
        
        cancelButton <- [
            Top(10).to(submitButton, .bottom),
            CenterX(0),
            Width(Screen.width - 40),
            Height(44)
        ]
    }
    
    func fetchUserInfo() {
        SVProgressHUD.show()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        User.fetchUsers(uid: uid) { (balance, email, isInvestor, token, userData) in
            User.fetchUserName(uid: uid, completion: { (name, surname, patronymic) in
                let firstLetter = name!.characters.first
                self.userInfoLabel.name.text = "\(surname!) \(firstLetter!)."
                self.userInfoLabel.email.text = "\(email!)"
                self.userInfoLabel.balance.text = "\(balance!) Тг."
                SVProgressHUD.dismiss()
                self.userRefillView.refillAmountTextField.text = ""
            })
        }
    }
    
    func backButtonPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func submitButtonPressed(sender: UIButton) {
        guard let amount = self.userRefillView.refillAmountTextField.text, self.userRefillView.refillAmountTextField.text != "" else { return }
        let alert = SCLAlertView()
        alert.addButton("Подтверждаю") {
            SVProgressHUD.show()
            guard let uid = Auth.auth().currentUser?.uid else { return }
            User.fetchUsers(uid: uid, compleation: { (balance, email, isInvestor, token, userData) in
                let newAmount = Int(amount)! + balance!
                User.setInvestorFinance(uid: uid, amount: newAmount, compleation: { (isCorrect) in
                    self.fetchUserInfo()
                    guard let isCorrect = isCorrect else { return }
                    if isCorrect {
                        self.successBanner.show()
                    } else {
                        self.errorBanner.show()
                    }
                })
            })
        }
        alert.showInfo("One more step", subTitle: "Подтвердите перевод")
    }
}
