//
//  BorrowTableViewCell.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

class BorrowTableViewCell: UITableViewCell {
    
    let sizeX = UIScreen.main.bounds.width - 20
    
    lazy var container: BarrowContainer = {
        let container = BarrowContainer()
        container.backgroundColor = .white
        container.layer.cornerRadius = 4
        return container
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Запрос", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.backgroundColor = .blueBackground
        return button
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1
        label.textAlignment = .center
        return label
    }()
    
    lazy var investorButtonAccept: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Принять", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.backgroundColor = .cyan
        return button
    }()
    
    lazy var investorButtonDecline: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Отклонить", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.backgroundColor = .cyan
        return button
    }()
    
    lazy var investorIssue: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Оформить", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.backgroundColor = .cyan
        return button
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
        self.addSubview(container)
        container.addSubview(button)
        container.addSubview(label)
        container.addSubview(investorButtonAccept)
        container.addSubview(investorButtonDecline)
        container.addSubview(investorIssue)
    }
    
    func setupConstraints() {
        container <- [
            Height(135),
            Width(sizeX),
            Center(0)
        ]
        
        button <- [
            Right(10),
            Bottom(0).to(container.thirdField.image, .bottom),
            Height(30),
            Width(130)
        ]
        
        label <- [
            Right(10),
            Bottom(0).to(container.thirdField.image, .bottom),
            Height(30),
            Width(130)
        ]
        
        investorButtonDecline <- [
            Right(10),
            Bottom(0).to(container.thirdField.image, .bottom),
            Height(30),
            Width(130)
        ]
        
        investorButtonAccept <- [
            Right(10).to(investorButtonDecline, .left),
            Bottom(0).to(container.thirdField.image, .bottom),
            Height(30),
            Width(130)
        ]
        
        investorIssue <- [
            Right(10),
            Bottom(0).to(container.thirdField.image, .bottom),
            Height(30),
            Width(130)
        ]
    }
}
