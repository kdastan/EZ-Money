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
    
    lazy var cardNumberTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.placeholder = "Номер карты"
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 4
        return textField
    }()
    
    lazy var cardExpirationTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.placeholder = "Срок карты"
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.layer.cornerRadius = 4
        return textField
    }()
    
    lazy var expirationDate: UIDatePicker = {
        let date = UIDatePicker()
        date.datePickerMode = .date
        date.addTarget(self, action: #selector(dateValueChanged(sender:)), for: .valueChanged)
        return date
    }()
    
    lazy var cardCodeTextField: PaddingTextFieldForUserData = {
        let textField = PaddingTextFieldForUserData()
        textField.placeholder = "CVV"
        textField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.1)
        textField.layer.cornerRadius = 4
        textField.keyboardType = .numberPad
        return textField
    }()
    
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
        [cardNumberTextField, cardExpirationTextField, cardCodeTextField, refillAmountTextField].forEach{
            addSubview($0)
        }
        dateFormatter.dateFormat = "MM/yyyy"
        cardExpirationTextField.inputView = expirationDate
    }
    
    func setupConstraints(){
        cardNumberTextField <- [
            Top(22),
            CenterX(0),
            Width(Screen.width - 40)
            
        ]
        
        cardExpirationTextField <- [
            Top(10).to(cardNumberTextField, .bottom),
            Left(10),
            Width(sizeX)
            
        ]
        
        cardCodeTextField <- [
            Top(10).to(cardNumberTextField, .bottom),
            Right(10),
            Width(sizeX)
            
        ]
        
        refillAmountTextField <- [
            Top(10).to(cardCodeTextField, .bottom),
            CenterX(0),
            Width(Screen.width - 40)
            
        ]
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        cardExpirationTextField.text = dateFormatter.string(from: sender.date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
