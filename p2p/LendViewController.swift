//
//  LendViewController.swift
//  p2p
//
//  Created by Apple on 02.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import NotificationBannerSwift
import SCLAlertView
import SwiftValidator

class LendViewController: UIViewController {
    
    let banner = NotificationBanner(title: "Запрос на инвестицию прошел успешно", subtitle: "Успех", style: .success)
    let infoBanner = NotificationBanner(title: "Пожалуйста заполните все поля", subtitle: ";(", style: .info)
    let banner2 = NotificationBanner(title: "Пожалуйста заполните все правильно", subtitle: ";(", style: .info)
    
    let validator = Validator()

    lazy var container: Container2 = {
        let container = Container2()
        return container
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Инвестировать", for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(container)
        container.addSubview(button)
        view.backgroundColor = .blueBackground
        banner.duration = 1
        infoBanner.duration = 1
        textFieldValidation()
    }
    
    func setupConstraints() {
        container <- [
            Width(Screen.width - 20),
            Height(300),
            Top(20),
            CenterX(0)
        ]
        
        button <- [
            CenterX(0),
            Bottom(10),
            Width(180),
            Height(50)
        ]
    }
    
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
        
        validator.registerField(container.container.investmentField.textField, errorLabel: nil, rules: [NumbersValidation()])
        validator.registerField(container.container.periodField.textField, errorLabel: nil, rules: [NumbersValidation()])
        validator.registerField(container.container.percentField.textField, errorLabel: nil, rules: [NumbersValidation()])
    }
    
    func pressed() {
        validator.validate(self)
    }
    
    func currentDate() -> String {
        let data = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/YYYY"
        let result = formatter.string(from: data)
        return result
    }
}

extension LendViewController: ValidationDelegate {
    func validationSuccessful() {
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let fieldMoney = container.container.investmentField.textField.text, let fieldTime = container.container.periodField.textField.text, let fieldRate = container.container.percentField.textField.text else {
        
            infoBanner.show()
            return
        }
        
        let appearance = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Подтверждаю"){
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let isData = value?["userData"] as? Bool ?? false
            if isData {
                let newRef = ref.child("investorRequests").childByAutoId()
                let post: [String: Any] = [
                    "amount": fieldMoney,
                    "date": self.currentDate(),
                    "id": newRef.key,
                    "investorId": uid,
                    "rate": fieldRate,
                    "time": fieldTime
                ]
                newRef.setValue(post)
            } else {
                self.present(MenuMyDataViewController(), animated: true, completion: nil)
            }
            }) {(error) in
                print(error.localizedDescription)
            }
            self.banner.show()
        }
        alertView.showWarning("Отправить запрос?", subTitle: "\(fieldMoney) Тенге,  \n на \(fieldTime) месяцев под \(fieldRate) % годовых", closeButtonTitle: "Отменить", colorStyle: 0x4BA2D3, colorTextButton: 0xE3F2FC)
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
       self.banner2.show()
    }

}
