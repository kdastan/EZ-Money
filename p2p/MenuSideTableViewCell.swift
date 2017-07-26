//
//  MenuSideTableViewCell.swift
//  p2p
//
//  Created by Apple on 26.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class MenuSideTableViewCell: UITableViewCell {
    
    

    lazy var iconImage: UIImageView = {
        let iconImage = UIImageView()
        return iconImage
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        self.addSubview(iconImage)
        self.addSubview(label)
    }
    
    func setupConstraints() {
        iconImage <- [
            CenterY(0),
            Left(30),
            Size(24)
        ]
        
        label <- [
            CenterY(0),
            Left(30).to(iconImage, .right),
            Width(100),
            Height(80)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
