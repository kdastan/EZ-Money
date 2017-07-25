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

    lazy var container: BarrowContainer = {
        let container = BarrowContainer()
        container.backgroundColor = .cyan
        return container
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
    }
    
    func setupConstraints() {
        container <- [
            Height(100),
            Width(300),
            Center(0)
        ]
    }
}
