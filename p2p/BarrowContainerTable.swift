//
//  BarrowContainer.swift
//  p2p
//
//  Created by Apple on 26.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class BarrowContainer: UIView {
    
    lazy var firstField: BarrowTableViewContainer = {
        let field = BarrowTableViewContainer()
        field.image.image = UIImage(named: "user")
        field.labelName.text = "Дина Динмухамед Аксерикович"
        return field
    }()
    
    lazy var secondField: BarrowTableViewContainer = {
        let field = BarrowTableViewContainer()
        field.image.image = UIImage(named: "hourglass")
        field.labelName.text = "6 месяцев"
        return field
    }()
    
    lazy var thirdField: BarrowTableViewContainer = {
        let field = BarrowTableViewContainer()
        field.image.image = UIImage(named: "percentage")
        field.labelName.text = "2.4 %"
        return field
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(firstField)
        self.addSubview(secondField)
        self.addSubview(thirdField)
        
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
    
        firstField <- [
            Bottom(15).to(secondField, .top),
            Left(10),
            Width(300),
            Height(20)
        ]
        
        secondField <- [
            CenterY(0),
            Left(10),
            Width(300),
            Height(20)
        ]
        
        thirdField <- [
            Top(15).to(secondField, .bottom),
            Left(10),
            Width(300),
            Height(20)
        ]
        
    }
    
    

}
