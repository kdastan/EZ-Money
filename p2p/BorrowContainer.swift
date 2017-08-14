//
//  BorrowContainer.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class BorrowContainer: UIView {
    
    
    let sizeX = UIScreen.main.bounds.width - 20

    lazy var field: ContainerContent = {
        let field = ContainerContent()
        field.imageView.image = UIImage(named: "coins")
        field.label.text = "Сумма займа"
        //field.backgroundColor = .cyan
        return field
    }()
    
    lazy var field2: ContainerContent = {
        let field = ContainerContent()
        field.imageView.image = UIImage(named: "hourglass")
        field.label.text = "Срок (месяц)"
        //field.backgroundColor = .blue
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraint()
    }
    
    
    func setupView() {
        
        addSubview(field)
        addSubview(field2)
    
    }
    
    func setupConstraint() {
        
        field <- [
            Top(25),
            CenterX(0),
            Width(sizeX),
            Height(50)
        ]
        
        field2 <- [
            Top(20).to(field, .bottom),
            Left(0).to(field, .left),
            Width(0).like(field),
            Height(50)
        ]
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
