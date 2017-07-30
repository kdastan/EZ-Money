//
//  Container.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

class Container: UIView {
    
    let sizeX = UIScreen.main.bounds.width - 20
    let newSizeX = (UIScreen.main.bounds.width - 50)/2
    
    lazy var container: BorrowContainer = {
        let container = BorrowContainer()
        container.backgroundColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        container.layer.cornerRadius = 4
        return container
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(container)
        
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        container <- [
            Width(sizeX),
            Height(250),
            Top(10),
            CenterX(0)
        ]

    }
    
}

