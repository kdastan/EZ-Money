//
//  helpers.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit

func createTextField(_ isMail: Bool) -> TextFieldWithIcon {
    var textField: TextFieldWithIcon = {
        let textfield = TextFieldWithIcon()
        let myColor = UIColor.white
        textfield.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.3)
        textfield.layer.borderColor = myColor.cgColor
        textfield.layer.borderWidth = 2
        textfield.layer.cornerRadius = 15
        if isMail{
        textfield.attributedPlaceholder = NSAttributedString(string: "Почта", attributes: [NSForegroundColorAttributeName: UIColor.white])
        textfield.textColor = .white
        textfield.imageView.image = UIImage(named: "mail")
        }
        else{
            textfield.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSForegroundColorAttributeName: UIColor.white])
            textfield.textColor = .white
            textfield.imageView.image = UIImage(named: "password")
        }
        return textfield
    }()
    return textField
}

extension UIColor {
    static let blueBackground = UIColor(colorLiteralRed: 227/255, green: 242/255, blue: 253/255, alpha: 1)
}
