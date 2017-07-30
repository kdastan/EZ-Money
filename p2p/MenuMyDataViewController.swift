//
//  MenuMyDataViewController.swift
//  p2p
//
//  Created by Apple on 28.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import SwiftValidator

class MenuMyDataViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(press), for: .touchUpInside)
        return button
    }()
    
    let validator = Validator()
    
    
    lazy var fullNameTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = .white
        return text
    }()
    
    lazy var emailTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = .white
        return text
    }()
    
    lazy var emailConfirmTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = .white
        return text
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        return label
    }()
  

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        
        setupViews()
        setupConstraints()
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
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
       
        validator.registerField(fullNameTextField, rules: [FullNameRule()])
        validator.registerField(emailTextField, errorLabel: label, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
        validator.registerField(emailConfirmTextField, errorLabel: label2, rules: [ConfirmationRule(confirmField: emailTextField)])
        
    }
    
    func press() {
        //validator.validate(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(button)
        view.addSubview(fullNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(emailConfirmTextField)
        view.addSubview(label)
        view.addSubview(label2)
    }
    
    func setupConstraints() {
        button <- [
            
            Size(48),
            Top(0),
            CenterX(0)
            
        ]
        
        fullNameTextField <- [
            Height(50),
            Width(200),
            Center(0)
        ]
        
        emailTextField <- [
            Height(50),
            Width(200),
            Left(0).to(fullNameTextField, .left),
            Top(10).to(fullNameTextField, .bottom)
        ]
        
        emailConfirmTextField <- [
            Height(50),
            Width(200),
            Left(0).to(fullNameTextField, .left),
            Top(10).to(emailTextField, .bottom)
        ]
        
        label <- [
            Height(48),
            Width(150),
            Top(20),
            Left(20)
        ]
        
        label2 <- [
            Height(48),
            Width(150),
            Top(60),
            Left(20)
        ]
    }

}

extension MenuMyDataViewController: ValidationDelegate {
    func validationSuccessful() {
        print("Good")
        
        
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        print("Not Good")
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }

}
