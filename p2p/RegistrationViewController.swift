//
//  RegistrationView.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy

class RegistrationViewController: UIViewController {
    
    //MARK: Properties
    lazy var labelName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 32)
        label.textColor = .white
        label.text = "EZ Money"
        return label
    }()
    
    lazy var labelProjectName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 32)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.text = "Образовательная программа"
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
    
    //MARK: View configurations
    private func setupViews() {
        [imageView, labelName, labelProjectName].forEach {view.addSubview($0)}
        setupNavigationBar()
    }
    
    //MARK: NavigationBar configurations
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: Constraints configurations
    private func setupConstraint() {
        imageView <- [
            Width(Screen.width),
            Height(Screen.height)
        ]
        
        labelName <- [
            Top(80),
            CenterX(0),
            Width(Screen.width / 2),
            Height(40)
        ]
        
        labelProjectName <- [
            CenterX(0),
            Width(Screen.width - 20),
            Top(0).to(labelName, .bottom)
        ]
    }

}
