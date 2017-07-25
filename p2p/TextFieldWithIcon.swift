//
//  TextFieldWithIcon.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class TextFieldWithIcon: UITextField {
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.contentMode = UIViewContentMode.scaleToFill
        return image
    }()

    let padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.addSubview(imageView)
    }
    
    private func configureConstraints() {
        imageView <- [
            CenterY(0),
            Left(10),
            Width(24),
            Height(16)
        ]
    }
}
