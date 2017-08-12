//
//  MenuHeaderView.swift
//  p2p
//
//  Created by Apple on 27.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

class MenuHeaderView: UIView {
    
    lazy var avatar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "boy")
        image.contentMode = .center
        return image
    }()
    
    lazy var nameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var email: UILabel = {
        let label = UILabel()
        label.text = ""
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    
    
    
    
    func setupView() {
        addSubview(avatar)
        addSubview(nameInfoLabel)
        addSubview(email)
    }
    
    func setupConstraints() {
        avatar <- [
            Size(48),
            Left(10),
            CenterY(0)
        ]
        
        nameInfoLabel <- [
            Top(0).to(avatar, .top),
            Left(10).to(avatar, .right),
            Height(25)
        ]
        
        email <- [
            Bottom(0).to(avatar, .bottom),
            Left(10).to(avatar, .right),
            Height(20),
            Width(Screen.width / 2)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
