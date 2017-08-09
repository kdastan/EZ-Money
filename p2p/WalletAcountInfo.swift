//
//  WalletAcountInfo.swift
//  p2p
//
//  Created by Apple on 09.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class WalletAcountInfo: UIView {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.numberOfLines = 0
        return label
    }()

    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    lazy var email: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    lazy var balance: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(name)
        addSubview(emailLabel)
        addSubview(email)
        addSubview(balanceLabel)
        addSubview(balance)
    }
    
    func setupConstraints() {
        nameLabel <- [
            Top(0),
            Left(0),
            Width(80)
        ]
        
        name <- [
            Top(0).to(nameLabel, .top),
            Left(10).to(nameLabel, .right),
            Width(Screen.width - 120)
        ]
        
        emailLabel <- [
            Top(15).to(nameLabel, .bottom),
            Left(0),
            Width(45)
        ]
        
        email <- [
            Top(0).to(emailLabel, .top),
            Left(10).to(emailLabel, .right),
            Width(Screen.width - 80)
        ]
        
        balanceLabel <- [
            Top(15).to(emailLabel, .bottom),
            Left(0),
            Width(130)
        ]
        
        balance <- [
            Top(0).to(balanceLabel, .top),
            Left(10).to(balanceLabel, .right),
            Width(Screen.width - 80)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
