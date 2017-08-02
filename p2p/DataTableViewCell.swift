//
//  DataTableViewCell.swift
//  p2p
//
//  Created by Apple on 02.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class DataTableViewCell: UITableViewCell {

    lazy var field: MenuFieldContainer = {
        let field = MenuFieldContainer()
        return field
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(field)
    }
    
    func setupConstraints() {
        field <- [
            CenterX(0),
            CenterY(0),
            Width(Screen.width),
            Height(75)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
