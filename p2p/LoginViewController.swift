//
//  LoginViewController.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import SVProgressHUD
import NotificationBannerSwift


class LoginViewController: RegistrationViewController {
    
    //MARK: Properties
    let banner = NotificationBanner(title: "Необходимо подтверждение", subtitle: "Проверьте свою почту", style: .success)
    let errorBanner = NotificationBanner(title: "Ошибка авторизации", subtitle: nil, style: .warning)
    
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
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.addTarget(self, action: #selector(passwordReset), for: .touchUpInside)
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        button.layer.cornerRadius = 4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
            }
    
    //MARK: Views configurations
    func setupView() {
        view.backgroundColor = .white
        [imageView, labelName, labelProjectName, textField, textFieldPassword, button, registrationButton, forgotPasswordButton].forEach{
            view.addSubview($0)
        }
    }
    
    //MARK: Constraints configurations
    func setupConstraints() {
        imageView <- [
            Width(Screen.width),
            Height(Screen.height)
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
            Top(Screen.height / 4 * 3),
            CenterX(0)
        ]
        
        registrationButton <- [
            Width(240),
            Height(21),
            Top(10).to(button, .bottom),
            CenterX(0)
        ]
        
        forgotPasswordButton <- [
            Width(150),
            Height(21),
            CenterX(0),
            Top(10).to(textFieldPassword, .bottom)
        
        ]
    }
    
    // MARK: User interactions
    func registrationButtonPressed() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    func submitButtonPressed() {
        
        SVProgressHUD.show()
        guard let text = textField.text, let text2 = textFieldPassword.text else { return }
        
        Auth.auth().signIn(withEmail: text, password: text2) { (user, error) in
            if let error = error {
                self.errorBanner.duration = 1
                self.errorBanner.show()
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                return
            } 
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference()
            
            if (user?.isEmailVerified)! {
                appDelegate.isLogged = true
                
                ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    let isInvestor = value?["isInvestor"] as? Bool ?? false
                    
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                    appDelegate.isInvestor = isInvestor
                    
                    let token = Messaging.messaging().fcmToken
                    ref.child("users").child("\(uid)").child("token").setValue(token)
  
                    appDelegate.cordinateAppFlow()
                    SVProgressHUD.dismiss()
                }){(error) in
                    print(error.localizedDescription)
                }
                
            } else {
                self.banner.show()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func passwordReset() {
        self.navigationController?.pushViewController(PasswordResetViewController(), animated: true)
    
    }
}
