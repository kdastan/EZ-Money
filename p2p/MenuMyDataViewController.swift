//
//  MenuMyDataViewController.swift
//  p2p
//
//  Created by Apple on 28.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import SwiftValidator
import JVFloatLabeledTextField
import LTHRadioButton

class MenuMyDataViewController: UIViewController {
    
    let firstStep = false
    
    let sizeWidth = UIScreen.main.bounds.width-15
    
    let validator = Validator()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 24)
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(validatorButton), for: .touchUpInside)
        return button
    }()
    
    lazy var userName: MenuFieldContainer = {
        let userNameField = MenuFieldContainer()
        userNameField.textField.placeholder = "Имя"
        return userNameField
    }()
    
    lazy var userSurname: MenuFieldContainer = {
        let userSurnameField = MenuFieldContainer()
        userSurnameField.textField.placeholder = "Фамилия"
        return userSurnameField
    }()

    lazy var userPatronymic: MenuFieldContainer = {
        let userPatronymicField = MenuFieldContainer()
        userPatronymicField.textField.placeholder = "Отчество"
        return userPatronymicField
    }()
    
    lazy var userMobilePhone: MenuFieldContainer = {
        let userMobilePhoneField = MenuFieldContainer()
        userMobilePhoneField.textField.placeholder = "Номер моб. телефона без +7 или 8"
        userMobilePhoneField.isHidden = true
        return userMobilePhoneField
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
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
       
        validator.registerField(userName.textField, errorLabel: userName.labelError, rules: [SSNVRule()])
        validator.registerField(userSurname.textField, errorLabel: userSurname.labelError, rules: [SSNVRule()])
        validator.registerField(userPatronymic.textField, errorLabel: userPatronymic.labelError, rules: [SSNVRule()])
        
        
        
        
    }
    
    func validatorButton() {
        //validator.validate(self)
        self.dismiss(animated: true, completion: nil)
    }

    
    func setupViews() {
        [userName, userSurname, userPatronymic, userMobilePhone, label, button].forEach{
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        
        label <- [
            Width(UIScreen.main.bounds.width),
            Height(44),
            CenterX(0),
            Top(44)
        ]
        
        userName <- [
            Width(sizeWidth),
            Height(70),
            CenterX(0),
            Top(10).to(label, .bottom)
        ]
        
        userSurname <- [
            Width(sizeWidth),
            Height(70),
            CenterX(0),
            Top(5).to(userName, .bottom)
        ]
        
        userPatronymic <- [
            Width(sizeWidth),
            Height(70),
            CenterX(0),
            Top(5).to(userSurname, .bottom)
        ]
        
        userMobilePhone <- [
            Width(sizeWidth),
            Height(70),
            CenterX(0),
            Top(10).to(label, .bottom)
        ]
        
        
        button <- [
            Width(UIScreen.main.bounds.width),
            Height(44),
            CenterX(0),
            Bottom(0)
        ]
    }

}

extension MenuMyDataViewController: ValidationDelegate {
    func validationSuccessful() {
        if !firstStep {
            userName.isHidden = true
            userSurname.isHidden = true
            userPatronymic.isHidden = true
            
            userMobilePhone.isHidden = false
            
            validator.registerField(userMobilePhone.textField, errorLabel: userMobilePhone.labelError, rules: [phoneValidation()])
        }
    }
        
        
    

    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        print("Not Good")
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
    



