//
//  PasswordResetViewController.swift
//  p2p
//
//  Created by Apple on 16.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import NotificationBannerSwift
import SVProgressHUD

class PasswordResetViewController: RegistrationViewController {
    
    //MARK: Properties
    let successBanner = NotificationBanner(title: "Мы отправили вам письмо", subtitle: nil, style: .success)
    let badEmailBanner = NotificationBanner(title: "Поле заполнено не верно", subtitle: nil, style: .warning)
    let emptyTextFieldBanner = NotificationBanner(title: "Пожалуйста заполните поле", subtitle: nil, style: .warning)

    lazy var textField = createTextField(true)
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        label.text = "Востановление пароля"
        label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Подтвердить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        button.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.7)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(textField)
        view.addSubview(label)
        view.addSubview(button)
        
        successBanner.duration = 1
        badEmailBanner.duration = 1
        emptyTextFieldBanner.duration = 1
    }
    
    func setupConstraints() {
        textField <- [
            Width(280),
            Height(42),
            Center(0)
        ]
        
        label <- [
            Width(200),
            Height(21),
            Bottom(10).to(textField, .top),
            CenterX(0)
        ]
        
        button <- [
            Width(280),
            Height(42),
            Top(10).to(textField, .bottom),
            CenterX(0)
        ]
    }
    
    func resetPassword() {
        SVProgressHUD.show()
        
        guard let email = textField.text, textField.text != "" else {
            SVProgressHUD.dismiss()
            emptyTextFieldBanner.show()
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                SVProgressHUD.dismiss()
                self.badEmailBanner.show()
                print(error.localizedDescription)
                return
            }
            SVProgressHUD.dismiss()
            self.successBanner.show()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
