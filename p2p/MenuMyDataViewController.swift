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

class MenuMyDataViewController: UIViewController {
    
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.contentSize = CGSize(width: 300, height: 1200)
        return scroll
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(press), for: .touchUpInside)
        return button
    }()
    
    let validator = Validator()
    
    //MARK: User name information
    lazy var userName: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Имя"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    lazy var userSurname: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Фамилия"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    lazy var userPatronymic: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Отчество"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    //MARK: User name error labels
    lazy var labelUserNameError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    lazy var labelUserSurnameError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    lazy var labelUserPatronymicError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    //MARK: User phone information
    lazy var mobilePhone: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Моб. телефон: 8(xxx)xxx-xx-xx"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        text.keyboardType = .numberPad
        return text
    }()
    
    lazy var homePhone: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Раб. телефон: 8(xxxx)xx-xx-xx"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        text.keyboardType = .numberPad
        return text
    }()
    
    //MARK: User date information
    lazy var birthDate: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Год рождения"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    lazy var birthPlace: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Место рождения"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    //MARK: User document information
    lazy var idNumber: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Номер документа"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    lazy var iinNumber: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "ИИН"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    lazy var issuingAuthority: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Место выдочи"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    lazy var dateOfIssue: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Дата выдачи"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()
    
    lazy var validatyDate: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Дата истечения"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        
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
       
        
        validator.registerField(userName, errorLabel: labelUserNameError, rules: [SSNVRule()])
        validator.registerField(userSurname, errorLabel: labelUserSurnameError, rules: [FullNameRule()])
        validator.registerField(userPatronymic, errorLabel: labelUserPatronymicError, rules: [FullNameRule()])
        //validator.registerField(emailTextField, errorLabel: label, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        //validator.registerField(emailConfirmTextField, errorLabel: label2, rules: [ConfirmationRule(confirmField: emailTextField)])
        
        
    }
    
    func press() {
        validator.validate(self)
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(scroll)
        scroll.addSubview(button)
        
        scroll.addSubview(userName)
        scroll.addSubview(userSurname)
        scroll.addSubview(userPatronymic)
        scroll.addSubview(mobilePhone)
        scroll.addSubview(homePhone)
        scroll.addSubview(birthDate)
        scroll.addSubview(birthPlace)
        scroll.addSubview(idNumber)
        scroll.addSubview(iinNumber)
        scroll.addSubview(dateOfIssue)
        scroll.addSubview(issuingAuthority)
        scroll.addSubview(validatyDate)
        
        scroll.addSubview(labelUserNameError)
        scroll.addSubview(labelUserSurnameError)
        scroll.addSubview(labelUserPatronymicError)
    }
    
    func setupConstraints() {
        edgesForExtendedLayout = []
        scroll <- [
            Width(UIScreen.main.bounds.width),
            Height(UIScreen.main.bounds.height),
            Top(0),
            Left(0)
        ]
        
        labelUserNameError <- [
            Height(10),
            Left(18),
            Top(40)
        ]
        
        userName <- [
            Height(50),
            Width(300),
            Top(6).to(labelUserNameError, .bottom),
            Left(8)
        ]
        
        labelUserSurnameError <- [
            Height(10),
            Left(18),
            Top(10).to(userName, .bottom)
        ]
        
        userSurname <- [
            Height(50),
            Width(300),
            Left(8),
            Top(6).to(labelUserSurnameError, .bottom)
        ]
        
        labelUserPatronymicError <- [
            Height(10),
            Left(18),
            Top(10).to(userSurname, .bottom)
        ]
        
        userPatronymic <- [
            Height(50),
            Width(300),
            Left(8),
            Top(6).to(labelUserPatronymicError, .bottom)
        ]
        
        mobilePhone <- [
            Height(50),
            Width(300),
            Left(0).to(userPatronymic, .left),
            Top(10).to(userPatronymic, .bottom)
        ]
        
        homePhone <- [
            Height(50),
            Width(300),
            Left(0).to(mobilePhone, .left),
            Top(10).to(mobilePhone, .bottom)
        ]
        
        birthDate <- [
            Height(50),
            Width(200),
            Left(0).to(homePhone, .left),
            Top(10).to(homePhone, .bottom)
        ]
        
        birthPlace <- [
            Height(50),
            Width(200),
            Left(0).to(birthDate, .left),
            Top(10).to(birthDate, .bottom)
        ]
        
        idNumber <- [
            Height(50),
            Width(200),
            Left(0).to(birthPlace, .left),
            Top(10).to(birthPlace, .bottom)
        ]
        
        iinNumber <- [
            Height(50),
            Width(200),
            Left(0).to(idNumber, .left),
            Top(10).to(idNumber, .bottom)
        ]
        
        dateOfIssue <- [
            Height(50),
            Width(200),
            Left(0).to(iinNumber, .left),
            Top(10).to(iinNumber, .bottom)
        ]
        
        validatyDate <- [
            Height(50),
            Width(200),
            Left(0).to(dateOfIssue, .left),
            Top(10).to(dateOfIssue, .bottom)
        ]
        
        issuingAuthority <- [
            Height(50),
            Width(200),
            Left(0).to(validatyDate, .left),
            Top(10).to(validatyDate, .bottom)
        ]
        
        button <- [
            Size(48),
            Top(10).to(issuingAuthority, .bottom),
            CenterX(0)
        ]
       
    }

}

extension MenuMyDataViewController: ValidationDelegate {
    func validationSuccessful() {
        print("Good")
        
        
        
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
