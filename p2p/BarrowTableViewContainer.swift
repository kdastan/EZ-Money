//
//  BarrowTableViewContainer.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class BarrowTableViewContainer: UIView {
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var labelName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
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
        self.addSubview(image)
        self.addSubview(labelName)
    }
    
    func setupConstraints() {
        image <- [
            Size(24),
            Left(16),
            CenterY(0)
        ]
        
        labelName <- [
            Width(Screen.width - 92),
            CenterY(0),
            Left(16).to(image, .right)
        ]
    }
}
