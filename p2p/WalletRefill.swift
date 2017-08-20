//
//  WalletRefill.swift
//  p2p
//
//  Created by Apple on 09.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import JVFloatLabeledTextField

class WalletRefill: UIView {
    
    let sizeX = (Screen.width - 50) / 2
    let dateFormatter = DateFormatter()
    
    lazy var refillAmountTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.placeholder = "Сумма пополнения"
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.layer.cornerRadius = 4
        textField.keyboardType = .numberPad
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        [refillAmountTextField].forEach{
            addSubview($0)
        }
    }
    
    func setupConstraints(){
        
        refillAmountTextField <- [
            Top(22),
            CenterX(0),
            Width(Screen.width - 40)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
