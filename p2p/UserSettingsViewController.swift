//
//  UserSettingsViewController.swift
//  p2p
//
//  Created by Apple on 10.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import NotificationBannerSwift
import SwiftValidator
import SVProgressHUD

class UserSettingsViewController: UIViewController {
    
    //MARK: Properties
    let successBanner = NotificationBanner(title: "Успешно", subtitle: "Ваш пароль изменен", style: .success)
    let oldPasswordBanner = NotificationBanner(title: "Текущий пароль введен неверно", subtitle: "", style: .warning)
    let newPasswordsBanner = NotificationBanner(title: "Новые пароли не совпадают", subtitle: "", style: .warning)
    let strongBanner = NotificationBanner(title: "Новый пароль не достаточно надежный", subtitle: "", style: .warning)
    let validationBanner = NotificationBanner(title: "Пожалуйста заполните все поля", subtitle: "", style: .warning)
    
    let validator = Validator()
    
    let user = Auth.auth().currentUser
    
    lazy var passwordView: SettingsView = {
        let passwordView = SettingsView()
        return passwordView
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 4
        button.setTitle("Сменить пароль", for: .normal)
        button.addTarget(self, action: #selector(submitPressed(sender: )), for: .touchUpInside)
        button.backgroundColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 4
        
        button.setTitle("Назад", for: .normal)
        button.addTarget(self, action: #selector(backPressed(sender: )), for: .touchUpInside)
        button.backgroundColor = UIColor(colorLiteralRed: 213/255, green: 70/255, blue: 70/255, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: Views configuration
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(passwordView)
        view.addSubview(submitButton)
        inputValidation()
        bannerDuration()
    }
    
    //MARK: Constraints configuration
    func setupConstraints() {
        passwordView <- [
            Width(Screen.width - 20),
            Height(190),
            CenterX(0),
            Top(44)
        ]
        
        submitButton <- [
            Width(Screen.width - 40),
            Height(44),
            CenterX(0),
            Top(0).to(passwordView, .bottom)
        ]
        
        backButton <- [
            Top(10).to(submitButton, .bottom),
            CenterX(0),
            Width(Screen.width - 40),
            Height(44)
        ]
    }
    
    //MARK: Banners duration
    func bannerDuration() {
        successBanner.duration = 1
        oldPasswordBanner.duration = 1
        newPasswordsBanner.duration = 1
        strongBanner.duration = 1
        validationBanner.duration = 1
    }
    
    //MARK: User's password change
    func fetchUser() {
        guard let oldPassword = passwordView.oldPasswordTextField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        User.fetchUsers(uid: uid) { (balance, email, isInvestor, token, userData, password) in
            let das = EmailAuthProvider.credential(withEmail: email!, password: oldPassword)
            self.user?.reauthenticate(with: das) { error in
                if let _ = error {
                    SVProgressHUD.dismiss()
                    self.oldPasswordBanner.show()
                } else {
                    self.passwordSetup()
                }
            }
        }
    }
    
    func passwordSetup() {
        guard let newPassword = self.passwordView.newPasswordTextField.text else {return}
        guard let reNewPassword = self.passwordView.reNewPasswordTextField.text else {return}
        guard let currentUser = Auth.auth().currentUser else {return}
        
        if newPassword == reNewPassword {
            currentUser.updatePassword(to: newPassword, completion: { (error) in
                if let _ = error {
                    SVProgressHUD.dismiss()
                    self.strongBanner.show()
                } else {
                    SVProgressHUD.dismiss()
                    self.successBanner.show()
                    self.passwordView.oldPasswordTextField.text = ""
                    self.passwordView.newPasswordTextField.text  = ""
                    self.passwordView.reNewPasswordTextField.text = ""
                }
            })
        } else {
            SVProgressHUD.dismiss()
            self.newPasswordsBanner.show()
        }
    }
    
    //MARK: Text field validation
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
        
        validator.registerField(passwordView.oldPasswordTextField, errorLabel: nil, rules: [RequiredRule()])
        validator.registerField(passwordView.newPasswordTextField, errorLabel: nil, rules: [RequiredRule()])
        validator.registerField(passwordView.reNewPasswordTextField, errorLabel: nil, rules: [RequiredRule()])
    }

    //MARK: User interaction
    func backPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func submitPressed(sender: UIButton) {
        validator.validate(self)
        SVProgressHUD.show()
    }
}

extension UserSettingsViewController: ValidationDelegate {
    
    func validationSuccessful() {
        fetchUser()
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        SVProgressHUD.dismiss()
        validationBanner.show()
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

