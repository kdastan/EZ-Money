//
//  ContainerContent.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class ContainerContent: UIView {

    let sizeX = (UIScreen.main.bounds.width - 100)/2
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .white
        return label
    }()
    
    lazy var textField: PaddingTextField = {
        let text = PaddingTextField()
        //text.backgroundColor = .white
        text.layer.cornerRadius = 12
        text.backgroundColor = .white
        text.keyboardType = .numberPad
        return text
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
        [imageView, label, textField].forEach{
            addSubview($0)
        }
    }
    
    func setupConstraints(){
        imageView <- [
            CenterY(0),
            Left(16),
            Size(24)
        ]
        
        label <- [
            Width(sizeX),
            Height(25),
            CenterY(0),
            Left(16).to(imageView, .right)
        ]
        
        textField <- [
            Width(sizeX),
            Height(25),
            CenterY(0),
            Left(8).to(label, .right)
        ]
    }

}
