//
//  SettingsView.swift
//  p2p
//
//  Created by Apple on 10.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class SettingsView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Смена пароля"
        label.font = UIFont(name: "Helvetica", size: 24)
        return label
    }()
    
    lazy var oldPasswordTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.placeholder = "Введите текущий пароль"
        textField.layer.cornerRadius = 4
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var newPasswordTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.placeholder = "Введите новый пароль"
        textField.layer.cornerRadius = 4
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var reNewPasswordTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.placeholder = "Подтвердите новый пароль"
        textField.layer.cornerRadius = 4
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.isSecureTextEntry = true
        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
    }
    
    func setupView() {
        [label, oldPasswordTextField, newPasswordTextField, reNewPasswordTextField].forEach{
            addSubview($0)
        }
    }
    
    func setupConstrains() {
        label <- [
            Top(0),
            Left(10),
            Width(Screen.width-20)
        ]
        
        oldPasswordTextField <- [
            Top(10).to(label, .bottom),
            CenterX(0),
            Width(Screen.width - 40)
        ]
        
        newPasswordTextField <- [
            Top(10).to(oldPasswordTextField, .bottom),
            CenterX(0),
            Width(Screen.width - 40)
        ]
        
        reNewPasswordTextField <- [
            Top(10).to(newPasswordTextField, .bottom),
            CenterX(0),
            Width(Screen.width - 40)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
