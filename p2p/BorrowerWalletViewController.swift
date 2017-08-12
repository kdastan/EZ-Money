
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
import SwiftValidator

class BorrowerWalletViewController: UIViewController {
    
    let successBanner = NotificationBanner(title: "Успещное снятие", subtitle: "", style: .success)
    let errorBanner = NotificationBanner(title: "Возникла ошибка", subtitle: "Попробуйте повторить позже", style: .warning)
    let inputErrorBanner = NotificationBanner(title: "Ошибка ввода", subtitle: "Пожалуйста заполните все поля", style: .warning)
    let incorrectAmount = NotificationBanner(title: "Отмена", subtitle: "У вас не достаточно средств", style: .warning)
    
    let validator = Validator()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Снятие с кошелька"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 24)
        return label
    }()
    
    lazy var userInfoLabel: WalletAcountInfo = {
        let label = WalletAcountInfo()
        //label.nameLabel.adjustsFontSizeToFitWidth = true
        label.nameTextField.text = "Пользователь: "
        label.emailTextField.text = "Email: "
        label.balanceTextField.text = "Текущий баланс: "
        return label
    }()
    
    lazy var userRefillView: WalletRefill = {
        let refillView = WalletRefill()
        refillView.refillAmountTextField.placeholder = "Сумма снятия"
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
        button.setTitle("Снять", for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(submitButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        inputValidation()
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
            Height(130)
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
    
    
    
    func inputValidation() {
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
                
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
        validator.registerField(userRefillView.cardNumberTextField, errorLabel: nil, rules: [userCardValidation()])
        validator.registerField(userRefillView.cardExpirationTextField, errorLabel: nil, rules: [RequiredRule()])
        validator.registerField(userRefillView.cardCodeTextField, errorLabel: nil, rules: [userCardValidation()])
        validator.registerField(userRefillView.refillAmountTextField, errorLabel: nil, rules: [NumbersValidation()])
    }
    
    func fetchUserInfo() {
        SVProgressHUD.show()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        User.fetchUsers(uid: uid) { (balance, email, isInvestor, token, userData, password) in
            User.fetchUserName(uid: uid, completion: { (name, surname, patronymic) in
                let firstLetter = name!.characters.first
                self.userInfoLabel.nameTextField.text = "\(surname!) \(firstLetter!)."
                self.userInfoLabel.emailTextField.text = "\(email!)"
                self.userInfoLabel.balanceTextField.text = "\(balance!) Тг."
                SVProgressHUD.dismiss()
                self.userRefillView.refillAmountTextField.text = ""
                self.userRefillView.cardNumberTextField.text = ""
                self.userRefillView.cardExpirationTextField.text = ""
                self.userRefillView.cardCodeTextField.text = ""
            })
        }
    }
    
    func backButtonPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func submitButtonPressed(sender: UIButton) {
        validator.validate(self)
    }
}

extension BorrowerWalletViewController: ValidationDelegate {
    
    func validationSuccessful() {
        
        guard let amount = self.userRefillView.refillAmountTextField.text else {return}
        
        let alert = SCLAlertView()
        alert.addButton("Подтверждаю") {
            SVProgressHUD.show()
            guard let uid = Auth.auth().currentUser?.uid else { return }
            User.fetchUsers(uid: uid, compleation: { (balance, email, isInvestor, token, userData, password) in
                //Сумма снятия больше чем осн сумма
                if balance! < Int(amount)! {
                    SVProgressHUD.dismiss()
                    self.incorrectAmount.show()
                } else {
                let newAmount = balance! - Int(amount)!
                User.setInvestorFinance(uid: uid, amount: newAmount, compleation: { (isCorrect) in
                    self.fetchUserInfo()
                    guard let isCorrect = isCorrect else { return }
                    if isCorrect {
                        self.successBanner.show()
                    } else {
                        self.errorBanner.show()
                    }
                })
                }
            })
        }
        alert.showInfo("One more step", subTitle: "Подтвердите снятие")
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        inputErrorBanner.show()
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
