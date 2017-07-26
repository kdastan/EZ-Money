//
//  BorrowTableViewCell.swift
//  p2p
//
//  Created by Apple on 25.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

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
        button.setTitle("Запросить", for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.backgroundColor = .blueBackground
        button.addTarget(self, action: #selector(pressd(sender: )), for: .touchUpInside)
        return button
    }()
    
    func pressd(sender: UIButton) {
        let buttonRow = sender.tag
        print(buttonRow)
    }
    
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
    }
}
