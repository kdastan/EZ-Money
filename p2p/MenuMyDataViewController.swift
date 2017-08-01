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
    
    var firstStep = false
    var secondStep = false
    var thirdStep = false
    
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.isUserInteractionEnabled = true
        scroll.contentSize = CGSize(width: 300, height: 1200)
        return scroll
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .orange
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
        text.placeholder = "Моб. телефон: без 8 или +7"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        text.keyboardType = .numberPad
        text.isHidden = true
        return text
    }()
    
    lazy var homePhone: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Раб. телефон: без 8 или +7"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        text.keyboardType = .numberPad
        text.isHidden = true
        return text
    }()
    
    //MARK: User phone error labels
    lazy var labelMobilePhoneError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    lazy var labelHomePhoneError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    //MARK: User date information
    lazy var bDay: UILabel = {
        let date = UILabel()
        date.text = "День рождения"
        date.isHidden = true
        return date
    }()
    
    lazy var birthDate: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.isHidden = true
        return datePicker
    }()
    
    lazy var birthPlace: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Место рождения"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        text.isHidden = true
        return text
    }()
    
    //MARK: User birth error label
    lazy var labelBirthPlaceError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    //MARK: User document information
    lazy var idNumber: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Номер документа"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        text.keyboardType = .numberPad
        text.isHidden = true
        return text
    }()
    
    lazy var iinNumber: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "ИИН"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        text.keyboardType = .numberPad
        text.isHidden = true
        return text
    }()
    
    lazy var issuingAuthority: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.placeholder = "Место выдочи"
        text.backgroundColor = .white
        text.layer.cornerRadius = 10
        text.floatingLabelXPadding = 5
        text.isHidden = true
        return text
    }()
    
    lazy var dateOfIssue: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.isHidden = true
        return date
    }()
    
    lazy var validatyDate: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.isHidden = true
        return date
    }()
    
    lazy var labelDateOfIssue: UILabel = {
        let label = UILabel()
        label.text = "Дата выпуска документа"
        
        label.isHidden = true
        return label
    }()
    
    lazy var labelValidatyDate: UILabel = {
        let label = UILabel()
        label.text = "Срок истечения документа"
        
        label.isHidden = true
        return label
    }()
    
    //MARK: User documents error label
    lazy var labelIdNumberError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        
        return label
    }()
    
    lazy var labeliinNumberError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        
        return label
    }()
    
    
    
    lazy var labelissuingAuthorityError: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Helvetica", size: 12)
        
        return label
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
        validator.registerField(userSurname, errorLabel: labelUserSurnameError, rules: [SSNVRule()])
        validator.registerField(userPatronymic, errorLabel: labelUserPatronymicError, rules: [SSNVRule()])
        
        
        //validator.registerField(emailTextField, errorLabel: label, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        //validator.registerField(emailConfirmTextField, errorLabel: label2, rules: [ConfirmationRule(confirmField: emailTextField)])
        
        
    }
    
    func press() {
        validator.validate(self)
        
        //self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(scroll)
        
        [userName, userSurname, userPatronymic, mobilePhone, homePhone, birthDate, birthPlace, idNumber, iinNumber, dateOfIssue, issuingAuthority, validatyDate, labelUserNameError, labelUserSurnameError, labelUserPatronymicError, labelMobilePhoneError, labelHomePhoneError, bDay, birthDate, labelBirthPlaceError, birthPlace, labelIdNumberError, labeliinNumberError, labelDateOfIssue, labelissuingAuthorityError, labelValidatyDate].forEach{
            scroll.addSubview($0)
        }
        
        view.addSubview(button)
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
            Height(14),
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
            Height(14),
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
            Height(14),
            Left(18),
            Top(10).to(userSurname, .bottom)
        ]
        
        userPatronymic <- [
            Height(50),
            Width(300),
            Left(8),
            Top(6).to(labelUserPatronymicError, .bottom)
        ]
        
        labelMobilePhoneError <- [
            Height(14),
            Left(18),
            Top(40)
        ]
        
        mobilePhone <- [
            Height(50),
            Width(300),
            Top(6).to(labelMobilePhoneError, .bottom),
            Left(8)
        ]
        
        labelHomePhoneError <- [
            Height(14),
            Left(18),
            Top(10).to(mobilePhone, .bottom)
        ]
        
        homePhone <- [
            Height(50),
            Width(300),
            Left(8),
            Top(6).to(labelHomePhoneError, .bottom)
        ]
        
        
        
        bDay <- [
            Height(16),
            Left(18),
            Top(40)
        ]
        
        birthDate <- [
            Height(200),
            Width(UIScreen.main.bounds.width),
            Left(0).to(homePhone, .left),
            Top(10).to(bDay, .bottom)
        ]
        
        labelBirthPlaceError <- [
            Height(14),
            Left(18),
            Top(10).to(birthDate, .bottom)
        ]
        
        birthPlace <- [
            Height(50),
            Width(300),
            Left(0).to(birthDate, .left),
            Top(10).to(labelBirthPlaceError, .bottom)
        ]
        
        
        
        
        
        
        labelIdNumberError <- [
            Height(14),
            Left(18),
            Top(40)
        ]
        
        idNumber <- [
            Height(50),
            Width(300),
            Top(6).to(labelIdNumberError, .bottom),
            Left(8)
        ]
        
        labeliinNumberError <- [
            Height(14),
            Left(18),
            Top(10).to(idNumber, .bottom)
        ]
        
        iinNumber <- [
            Height(50),
            Width(300),
            Top(6).to(labeliinNumberError, .bottom),
            Left(8)
        ]
        
        labelDateOfIssue <- [
            Height(14),
            Left(18),
            Top(10).to(iinNumber, .bottom)
        ]
        
        dateOfIssue <- [
            Height(200),
            Width(UIScreen.main.bounds.width),
            Top(6).to(labelDateOfIssue, .bottom),
            Left(8)
        ]
        
        labelValidatyDate <- [
            Height(16),
            Left(18),
            Top(10).to(dateOfIssue, .bottom)
        ]
        
        validatyDate <- [
            Height(200),
            Width(UIScreen.main.bounds.width),
            Top(6).to(labelValidatyDate, .bottom),
            Left(8)
        ]
        
        labelissuingAuthorityError <- [
            Height(16),
            Left(18),
            Top(10).to(validatyDate, .bottom)
        ]
        
        issuingAuthority <- [
            Height(50),
            Width(300),
            Top(6).to(labelissuingAuthorityError, .bottom),
            Left(8)
        ]
        
        
        
        
        
        
        
        
        
        
        
        button <- [
            Width(UIScreen.main.bounds.width),
            Height(48),
            Bottom(0),
            CenterX(0)
        ]
       
    }

}

extension MenuMyDataViewController: ValidationDelegate {
    func validationSuccessful() {
        if firstStep != true {
            firstStep = true
            mobilePhone.isHidden = false
            homePhone.isHidden = false
            
            userName.isHidden = true
            userSurname.isHidden = true
            userPatronymic.isHidden = true
            
            validator.registerField(mobilePhone, errorLabel: labelMobilePhoneError, rules: [phoneValidation()])
            validator.registerField(homePhone, errorLabel: labelHomePhoneError, rules: [phoneValidation()])
            
        } else if secondStep != true {
        
            secondStep = true
            mobilePhone.isHidden = true
            homePhone.isHidden = true
            
            birthDate.isHidden = false
            birthPlace.isHidden = false
            bDay.isHidden = false
            
            validator.registerField(birthPlace, errorLabel: labelBirthPlaceError, rules: [SSNVRule()])

        } else if thirdStep != true {
            
            thirdStep = true
        
            birthDate.isHidden = true
            birthPlace.isHidden = true
            bDay.isHidden = true
            
            idNumber.isHidden = false
            iinNumber.isHidden = false
            issuingAuthority.isHidden = false
            dateOfIssue.isHidden = false
            validatyDate.isHidden = false
            labelDateOfIssue.isHidden = false
            labelValidatyDate.isHidden = false
            
            validator.registerField(idNumber, errorLabel: labelIdNumberError, rules: [documentNumbersValidation()])
            validator.registerField(iinNumber, errorLabel: labeliinNumberError, rules: [documentNumbersValidation()])
            validator.registerField(issuingAuthority, errorLabel: labelissuingAuthorityError, rules: [SSNVRule()])
            //validator.registerField(dateOfIssue, errorLabel: labelDateOfIssueError, rules: [SSNVRule()])
            //validator.registerField(validatyDate, errorLabel: labelValidatyDateError, rules: [SSNVRule()])
        } else {
            self.dismiss(animated: true, completion: nil)
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
