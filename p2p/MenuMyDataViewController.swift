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
import SVProgressHUD
import NotificationBannerSwift

class MenuMyDataViewController: UIViewController {
    
    //MARK: Properties
    let banner = NotificationBanner(title: "Ошибка регистрации", subtitle: "Проверьте правильность заполнения полей", style: .info)
    
    let dateFormatter = DateFormatter()
    let validator = Validator()
    
    var userDataNew: Bool?
    
    let uid = Auth.auth().currentUser?.uid
    
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
        button.backgroundColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        button.addTarget(self, action: #selector(validatorButton), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.backgroundColor = UIColor(colorLiteralRed: 213/255, green: 70/255, blue: 70/255, alpha: 1)
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
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
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -21, to: Date())
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
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
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
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
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
        //setupConstraints()
    }
    
    //MARK: Views configuration
    func setupViews() {
        [scroll, button, cancelButton].forEach{ view.addSubview($0) }
        [label, userName, userSurname, userPatronymic, userMobilePhone, userPhone, userBirthDate, userBirthPlace, userIdNumber, userIINnumber, userDateOfIssue, userDateOfValidaty, userIssuingAuthority].forEach{ scroll.addSubview($0) }
        textFieldValidation()
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        dateFormatter.dateFormat = "dd/MM/yyyy"
        userBirthDate.textField.inputView = datePicker
        userDateOfIssue.textField.inputView = datePickerDateOfIssue
        userDateOfValidaty.textField.inputView = datePickerDateOfValidaty
        
        updateUserData(uid: uid!) { success in
            SVProgressHUD.dismiss()
        }
        
        updateUserData(uid: uid!) { (result, userData) in
            
            self.userDataNew = userData
            self.setupConstraints()
            
        }
    }
    
    //MARK: Constraints configuration
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
        
        cancelButton <- [
            Width(Screen.width / 2),
            Height(44),
            Left(0),
            Bottom(0)
        ]
        
        button <- [
            Width(Screen.width / 2).when({ () -> Bool in
                self.userDataNew == true
            }),
            Width(Screen.width).when({ () -> Bool in
                self.userDataNew == false
            }),
            Height(44),
            Right(0),
            Bottom(0)
        ]
    }
    
    //MARK: Text field validation
    func textFieldValidation() {
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
    
    //MARK: User interaction
    func validatorButton() {
        validator.validate(self)
    }
    
    func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: DatePicker configuration for inputView
    func dateValueChanged(sender: UIDatePicker) {
        userBirthDate.textField.text = dateFormatter.string(from: sender.date)
    }
    
    func dateIssueChanged(sender: UIDatePicker) {
        userDateOfIssue.textField.text = dateFormatter.string(from: sender.date)
    }
    
    func dateValidatyChanged(sender: UIDatePicker) {
        userDateOfValidaty.textField.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK: Fetch - user data: Need to optimize to model
    func updateUserData(uid: String, completionHandler: @escaping ((_ exist : Bool, Bool) -> Void)) {
        SVProgressHUD.show()
        let ref = Database.database().reference()
        ref.child("users").child("\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let userData = value?["userData"] as? Bool
            
            if userData! {
                    ref.child("userData").child("\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                        let valueUserData = snapshot.value as? NSDictionary
                        
                        self.userName.textField.text = valueUserData?["name"] as? String
                        self.userSurname.textField.text = valueUserData?["surname"] as? String
                        self.userPatronymic.textField.text = valueUserData?["patronymic"] as? String
                        self.userMobilePhone.textField.text = valueUserData?["mobilePhone"] as? String
                        self.userPhone.textField.text = valueUserData?["homePhone"] as? String
                        self.userBirthDate.textField.text = valueUserData?["birthDate"] as? String
                        self.userBirthPlace.textField.text = valueUserData?["birthPlace"] as? String
                        self.userIdNumber.textField.text = valueUserData?["idNumber"] as? String
                        self.userIINnumber.textField.text = valueUserData?["iinNumber"] as? String
                        self.userDateOfIssue.textField.text = valueUserData?["dateOfIssue"] as? String
                        self.userDateOfValidaty.textField.text = valueUserData?["validatyDate"] as? String
                        self.userIssuingAuthority.textField.text = valueUserData?["issuingAuthority"] as? String
                        
                        self.button.setTitle("Обновить", for: .normal)
                    }) {(error) in
                        print(error.localizedDescription)
                }
             completionHandler(true, userData!)
            } else {
                self.cancelButton.isEnabled = false
                self.cancelButton.isHidden = true
                self.button.frame = CGRect(x: 0, y: Screen.height - 44, width: Screen.width, height: 44)
                SVProgressHUD.dismiss()
                completionHandler(true, userData!)
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
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
        ref.child("users").child("\(uid)").child("userData").setValue(true)
        
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        banner.show()
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

