//
//  MenuFieldContainer.swift
//  p2p
//
//  Created by Apple on 01.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class MenuFieldContainer: UIView {
    
    let sizeX = UIScreen.main.bounds.width - 15

    lazy var labelError: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    lazy var textField: PaddingTextFieldForUserData = {
        let text = PaddingTextFieldForUserData()
        text.layer.cornerRadius = 10
        text.backgroundColor = .textFieldBackground
        text.placeholderColor = .placeholderColor
        return text
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(labelError)
        self.addSubview(textField)
    }
    
    func setupConstraints() {
        
        labelError <- [
            Height(14),
            Left(9),
            Top(0)
        ]
        
        textField <- [
            Height(50),
            Width(sizeX),
            Top(6).to(labelError, .bottom),
            CenterX(0)
        ]
        
    }

}
