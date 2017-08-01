//
//  RegistrationView.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class RegistrationView: UIViewController { // name change to Viewcontroller
    
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
        image.image = #imageLiteral(resourceName: "sample")
        image.contentMode = .scaleToFill
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraint()
    }
    
    private func setupViews() {
        [imageView, labelName, labelProjectName].forEach {view.addSubview($0)}
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupConstraint() {
        imageView <- [
            Width(Screen.width),
            Height(Screen.height)
        ]
        
        labelName <- [
            Top(Screen.height * 0.15),
            CenterX(0)
        ]
        
        labelProjectName <- [
            Top(0).to(labelName, .bottom),
            Left(-15).to(labelName, .right)
        ]
    }

}
