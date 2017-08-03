//
//  LendContainer.swift
//  p2p
//
//  Created by Apple on 02.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class LendContainer: UIView {
    
    lazy var investmentField: ContainerContent = {
        let field = ContainerContent()
        field.imageView.image = #imageLiteral(resourceName: "coins")
        field.label.text = "Сумма инвестиций"
        field.label.numberOfLines = 0
        return field
    }()
    
    lazy var periodField: ContainerContent = {
        let field = ContainerContent()
        field.imageView.image = #imageLiteral(resourceName: "hourglass")
        field.label.text = "Срок (месяц)"
        field.label.numberOfLines = 0
        return field
    }()
    
    lazy var percentField: ContainerContent = {
        let field = ContainerContent()
        field.imageView.image = #imageLiteral(resourceName: "percentage")
        field.label.text = "Процентная ставка"
        field.label.numberOfLines = 0
        return field
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        [investmentField, periodField, percentField].forEach{ addSubview($0) }
    }
    
    func setupConstraints() {
        investmentField <- [
            Top(25),
            CenterX(0),
            Width(Screen.width - 20),
            Height(65)
        ]
        
        periodField <- [
            Top(5).to(investmentField, .bottom),
            Left(0).to(investmentField, .left),
            Width(0).like(investmentField),
            Height(65)
        ]
        
        percentField <- [
            Top(5).to(periodField, .bottom),
            Left(0).to(periodField, .left),
            Width(0).like(periodField),
            Height(65)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
