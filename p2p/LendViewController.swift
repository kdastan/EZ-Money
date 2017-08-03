//
//  LendViewController.swift
//  p2p
//
//  Created by Apple on 02.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class LendViewController: UIViewController {

    lazy var container: Container2 = {
        let container = Container2()
        return container
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Инвестировать", for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(container)
        container.addSubview(button)
        view.backgroundColor = .blueBackground
    }
    
    func setupConstraints() {
        container <- [
            Width(Screen.width - 20),
            Height(300),
            Top(20),
            CenterX(0)
        ]
        
        button <- [
            CenterX(0),
            Bottom(10),
            Width(180),
            Height(50)
        ]
    }
    
    func pressed() {
        print("invest")
    }
    
}
