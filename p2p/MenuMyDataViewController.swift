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
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MenuMyDataViewController: UIViewController {
    
    let dateFormatter = DateFormatter()
    let validator = Validator()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 24)
        return label
    }()
    
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentSize = CGSize(width: Screen.width, height: 1150)
        return scroll
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Подтвердить", for: .normal)
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
        return userMobilePhoneField
    }()
    
    lazy var userPhone: MenuFieldContainer = {
        let userPhoneField = MenuFieldContainer()
        userPhoneField.textField.placeholder = "Номер дом. телефона без +7 или 8"
        return userPhoneField
    }()
    
    lazy var userBirthDate: MenuFieldContainer = {
        let userBirthDateField = MenuFieldContainer()
        userBirthDateField.textField.placeholder = "Дата рождения"
        return userBirthDateField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateValueChanged(sender:)), for: .valueChanged)
        return datePicker
    }()
    
    lazy var userBirthPlace: MenuFieldContainer = {
        let userBirthPlaceField = MenuFieldContainer()
        userBirthPlaceField.textField.placeholder = "Место рождения"
        return userBirthPlaceField
    }()
    
    lazy var userIdNumber: MenuFieldContainer = {
        let userIdNumberField = MenuFieldContainer()
        userIdNumberField.textField.placeholder = "Номер документа"
        userIdNumberField.textField.keyboardType = .numberPad
        return userIdNumberField
    }()
    
    lazy var userIINnumber: MenuFieldContainer = {
        let userIINnumberField = MenuFieldContainer()
        userIINnumberField.textField.placeholder = "ИИН документа"
        userIINnumberField.textField.keyboardType = .numberPad
        return userIINnumberField
    }()

    lazy var userDateOfIssue: MenuFieldContainer = {
        let userDateOfIssueField = MenuFieldContainer()
        userDateOfIssueField.textField.placeholder = "Дата выдачи документа"
        return userDateOfIssueField
    }()
    
    lazy var datePickerDateOfIssue: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateIssueChanged(sender:)), for: .valueChanged)
        return datePicker
    }()
    
    lazy var userDateOfValidaty: MenuFieldContainer = {
        let userDateOfValidatyField = MenuFieldContainer()
        userDateOfValidatyField.textField.placeholder = "Дата истечения документа"
        return userDateOfValidatyField
    }()
    
    lazy var datePickerDateOfValidaty: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateValidatyChanged(sender:)), for: .valueChanged)
        return datePicker
    }()
    
    lazy var userIssuingAuthority: MenuFieldContainer = {
        let userIssuingAuthorityLabel = MenuFieldContainer()
        userIssuingAuthorityLabel.textField.placeholder = "Орган выдачи: пример МВД или МЮ"
        return userIssuingAuthorityLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        [scroll, button].forEach{ view.addSubview($0) }
        [label, userName, userSurname, userPatronymic, userMobilePhone, userPhone, userBirthDate, userBirthPlace, userIdNumber, userIINnumber, userDateOfIssue, userDateOfValidaty, userIssuingAuthority].forEach{ scroll.addSubview($0) }
        textFieldValidation()
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        dateFormatter.dateFormat = "dd/MM/yyyy"
        userBirthDate.textField.inputView = datePicker
        userDateOfIssue.textField.inputView = datePickerDateOfIssue
        userDateOfValidaty.textField.inputView = datePickerDateOfValidaty
    }
    
    func setupConstraints() {
        label <- [
            Width(UIScreen.main.bounds.width),
            Height(44),
            CenterX(0),
            Top(44)
        ]
        
        scroll <- [
            Width(Screen.width),
            Height(Screen.height),
            Top(0),
            Left(0)
        ]
        
        userName <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(label, .bottom)
        ]
        
        userSurname <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(5).to(userName, .bottom)
        ]
        
        userPatronymic <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(5).to(userSurname, .bottom)
        ]
        
        userMobilePhone <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userPatronymic, .bottom)
        ]
        
        userPhone <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userMobilePhone, .bottom)
        ]
        
        userBirthDate <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userPhone, .bottom)
        ]
        
        userBirthPlace <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userBirthDate, .bottom)
        ]
        
        userIdNumber <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userBirthPlace, .bottom)
        ]
        
        userIINnumber <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userIdNumber, .bottom)
        ]
        
        userDateOfIssue <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userIINnumber, .bottom)
        ]
        
        userDateOfValidaty <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userDateOfIssue, .bottom)
        ]
        
        userIssuingAuthority <- [
            Width(Screen.width - 15),
            Height(70),
            CenterX(0),
            Top(10).to(userDateOfValidaty, .bottom)
        ]
        
        button <- [
            Width(UIScreen.main.bounds.width),
            Height(44),
            CenterX(0),
            Bottom(0)
        ]
    }
    
    func textFieldValidation() {
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
        validator.registerField(userMobilePhone.textField, errorLabel: userMobilePhone.labelError, rules: [phoneValidation()])
        validator.registerField(userPhone.textField, errorLabel: userPhone.labelError, rules: [phoneValidation()])
        validator.registerField(userBirthDate.textField, errorLabel: userBirthDate.labelError, rules: [RequiredRule()])
        validator.registerField(userBirthPlace.textField, errorLabel: userBirthPlace.labelError, rules: [SSNVRule()])
        validator.registerField(userIdNumber.textField, errorLabel: userIdNumber.labelError, rules: [documentNumbersValidation()])
        validator.registerField(userIINnumber.textField, errorLabel: userIINnumber.labelError, rules: [documentNumbersValidation()])
        validator.registerField(userDateOfIssue.textField, errorLabel: userDateOfIssue.labelError, rules: [RequiredRule()])
        validator.registerField(userDateOfValidaty.textField, errorLabel: userDateOfValidaty.labelError, rules: [RequiredRule()])
        validator.registerField(userIssuingAuthority.textField, errorLabel: userIssuingAuthority.labelError, rules: [SSNVRule()])
    }
    
    func validatorButton() {
        validator.validate(self)
    }

    func dateValueChanged(sender: UIDatePicker) {
        userBirthDate.textField.text = dateFormatter.string(from: sender.date)
    }
    
    func dateIssueChanged(sender: UIDatePicker) {
        userDateOfIssue.textField.text = dateFormatter.string(from: sender.date)
    }
    
    func dateValidatyChanged(sender: UIDatePicker) {
        userDateOfValidaty.textField.text = dateFormatter.string(from: sender.date)
    }
}

extension MenuMyDataViewController: ValidationDelegate {
    func validationSuccessful() {
        
        guard let name = userName.textField.text, let surname = userSurname.textField.text, let patronymic = userPatronymic.textField.text, let mobile = userMobilePhone.textField.text, let phone = userPhone.textField.text, let birthDate = userBirthDate.textField.text, let birthPlace = userBirthPlace.textField.text, let id = userIdNumber.textField.text, let iin = userIINnumber.textField.text, let dateIssue = userDateOfIssue.textField.text, let dateValidaty = userDateOfValidaty.textField.text, let authority = userIssuingAuthority.textField.text else { return }
        
        var post: [String: Any] = [
            "birthDate" : birthDate,
            "birthPlace" : birthPlace,
            "dateOfIssue" : dateIssue,
            "homePhone" : phone,
            "idNumber" : id,
            "iinNumber" : iin,
            "issuingAuthority" : authority,
            "mobilePhone" : mobile,
            "name" : name,
            "patronymic" : patronymic,
            "surname" : surname,
            "validatyDate" : dateValidaty
        ]
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("userData").child("\(uid)").setValue(post)
        
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

