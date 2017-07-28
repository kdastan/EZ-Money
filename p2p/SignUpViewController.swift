//
//  SignUpViewController.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import BEMCheckBox
import Firebase
import FirebaseDatabase

class SignUpViewController: RegistrationView {

    var tapped = false
    
    let ref = Database.database().reference()
    
    lazy var textField = createTextField(true)
    lazy var textFieldPassword = createTextField(false)
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.7)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
   
    lazy var cBox: BEMCheckBox = {
        let cBox = BEMCheckBox()
        cBox.boxType = BEMBoxType.square
        cBox.tintColor = .white
        cBox.onTintColor = .white
        cBox.onCheckColor = .white
        cBox.onFillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        
        return cBox
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Я - инвестор"
        label.textColor = .white
        //label.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        label.layer.cornerRadius = 10
        return label
    }()
    
    func signUpButtonPressed() {
        
        guard let text = textField.text, let text2 = textFieldPassword.text else {
            return
        }
        
        //, email, , password, token, userData
        
        let balance = 0
        let email = text
        let isInvestor = tapped
        let password = text2
        let token = InstanceID.instanceID().token()
        let userData = false
        
//        let post = ["balance": "Ashat",
//                    "Surname": "Kim" ]
//        
        //ref.child("users").childByAutoId().setValue(post)
        
        
        
        print(token)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        cBox.delegate = self 
        
        setupView()
        setupConstraints()
        
        
        
    }
    
    func setupView() {
        [imageView, labelName, labelProjectName, textField, textFieldPassword, button, cBox, label].forEach{
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        textField <- [
            Width(280),
            Height(42),
            Center(0)
        ]
        
        textFieldPassword <- [
            Width(280),
            Height(42),
            Top(10).to(textField, .bottom),
            Left(0).to(textField, .left)
        ]
        
        cBox <- [
            Size(20),
            Left(10).to(textFieldPassword, .left),
            Top(10).to(textFieldPassword, .bottom)
        ]
        
        label <- [
            Width(110),
            Height(20),
            Left(10).to(cBox, .right),
            CenterY(0).to(cBox)
        ]
        
        
        button <- [
            Width(280),
            Height(42),
            Top(halfSizeY*3),
            CenterX(0)
        ]
    }

}

extension SignUpViewController: BEMCheckBoxDelegate {

    func didTap(_ checkBox: BEMCheckBox) {
        tapped = !tapped
    }
}
