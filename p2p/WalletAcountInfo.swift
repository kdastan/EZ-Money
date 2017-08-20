//
//  WalletAcountInfo.swift
//  p2p
//
//  Created by Apple on 09.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class WalletAcountInfo: UIView {

    lazy var emailTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.layer.cornerRadius = 4
        textField.placeholder = "Электронная почта"
        textField.isEnabled = false
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        return textField
    }()
    
    lazy var balanceTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.layer.cornerRadius = 4
        textField.placeholder = "Текущий баланс"
        textField.isEnabled = false
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {
        addSubview(emailTextField)
        addSubview(balanceTextField)
    }
    
    func setupConstraints() {

        emailTextField <- [
            Top(0),
            CenterX(0),
            Width(Screen.width - 40)        ]
        
        balanceTextField <- [
            Top(10).to(emailTextField, .bottom),
            Left(0),
            Width(Screen.width - 40)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
