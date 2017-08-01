//
//  RadioButton.swift
//  p2p
//
//  Created by Apple on 01.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import LTHRadioButton

class RadioButton: UITableViewCell {
    
    private let selectedColor   = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
    private let deselectedColor = UIColor.lightGray
    
    lazy var radioButton: LTHRadioButton = {
        let radio = LTHRadioButton()
        return radio
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(radioButton)
        self.addSubview(label)
    }
    
    func setupConstraints() {
        radioButton <- [
            Left(12),
            CenterY(0),
            Size(12)
        ]
        
        label <- [
            CenterY(0),
            Left(12).to(radioButton, .right),
            Width(200),
            Height(20)
        ]
    }
    
    func update(with color: UIColor) {
        backgroundColor             = color
        radioButton.selectedColor   = color == .darkGray ? .white : selectedColor
        radioButton.deselectedColor = color == .darkGray ? .lightGray : deselectedColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            return radioButton.select(animated: animated)
        }
        radioButton.deselect(animated: animated)
    }
}
