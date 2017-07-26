//
//  LoginViewController.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class LoginViewController: RegistrationView {
    
    let sizeX = UIScreen.main.bounds.width
    
    lazy var textField = createTextField(true)
    lazy var textFieldPassword = createTextField(false)
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.7)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нет аккаунта? Создай тут", for: .normal)
        button.addTarget(self, action: #selector(registrationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    func registrationButtonPressed() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    func submitButtonPressed() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.isLogged = true
            appDelegate.cordinateAppFlow()
        }
        
        print("Submit button pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        print(sizeX)
        
        setupView()
        setupConstraints()
        
//        UINavigationController?.navigationBar.isTranslucent = true
    }
    
    func setupView() {
        [imageView, labelName, labelProjectName, textField, textFieldPassword, button, registrationButton].forEach{
            view.addSubview($0)
        }
    }
    
    
    //MARK:  constr
    func setupConstraints() {
        
        imageView <- [
            Width(SizeX),
            Height(SizeY)
        ]
        
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
        
        button <- [
            Width(280),
            Height(42),
            Top(halfSizeY*3),
            CenterX(0)
        ]
        
        registrationButton <- [
            Width(280),
            Height(42),
            Top(0).to(button, .bottom),
            CenterX(0)
        ]
    }
    
}
