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
import FirebaseAuth
import NotificationBannerSwift
import SVProgressHUD

class SignUpViewController: RegistrationView {

    var tapped = false
    
    var errorlabel = ""
    var banner: NotificationBanner?
    
    lazy var textField = createTextField(true)
    lazy var textFieldPassword = createTextField(false)
    
    enum errorType: String {
        case email = "Эл. адресс введен некорректно"
        case takenEmail = "Эл. адресс уже зарегистрирован"
        case shortPassword = "Пароль - 6 или более символов"
    }
    
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
        cBox.delegate = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: Configuarations
    
    func setupView() {
        view.backgroundColor = .white
        [imageView, labelName, labelProjectName, textField, textFieldPassword, button, cBox, label].forEach{
            view.addSubview($0)
        }
        banner?.duration = 1
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
            Top(Screen.height / 4 * 3),
            CenterX(0)
        ]
    }
    
    // MARK: User Interactions
    
    func signUpButtonPressed() {
        SVProgressHUD.show()
        guard let text = textField.text, let text2 = textFieldPassword.text, let token = InstanceID.instanceID().token() else { return }
        let balance = 0
        let email = text
        let isInvestor = tapped
        let password = text2
        let userData = false
        
        let post: [String: Any] = [
            "balance": balance,
            "email": email,
            "isInvestor": isInvestor,
            "password": password,
            "token": token,
            "userData": userData
        ]
        
        Auth.auth().createUser(withEmail: email, password: password){ (user, error) in
            if let error = error{
                if error.localizedDescription == "The email address is badly formatted." {
                    self.errorlabel = errorType.email.rawValue
                } else if error.localizedDescription == "The email address is already in use by another account." {
                    self.errorlabel = errorType.takenEmail.rawValue
                } else if error.localizedDescription == "The password must be 6 characters long or more." {
                    self.errorlabel = errorType.shortPassword.rawValue
                }
                self.banner = NotificationBanner(title: self.errorlabel, subtitle: nil, style: .warning)
                self.banner?.show()
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
                return
            } else {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                user?.sendEmailVerification(completion: nil)
                let ref = Database.database().reference()
                ref.child("users").child("\(uid)").setValue(post)
                
                self.banner = NotificationBanner(title: "Письмо отправлено", subtitle: "Проверьте почтовый ящик", style: .success)
                self.banner?.show()
                SVProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SignUpViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        tapped = !tapped
    }
}
