//
//  RegistrationView.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class RegistrationView: UIViewController {
    
    let halfSizeY = UIScreen.main.bounds.height/4
    
    let SizeX = UIScreen.main.bounds.width
    let SizeY = UIScreen.main.bounds.height
    
    lazy var labelName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 66)
        label.textColor = .white
        label.text = "AIFC"
        return label
    }()
    
    lazy var labelProjectName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 32)
        label.textColor = .white
        label.text = "p2p"
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sample")
        image.contentMode = .scaleToFill
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(labelName)
        view.addSubview(labelProjectName)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        
        setupConstraint()
    }
    
    func setupConstraint() {
    
        imageView <- [
            Width(SizeX),
            Height(SizeY)
        ]
        
        labelName <- [
            Top(SizeY*0.15),
            CenterX(0)
        ]
        
        labelProjectName <- [
            Top(0).to(labelName, .bottom),
            Left(-15).to(labelName, .right)
        ]
        
               
    
    }

}
