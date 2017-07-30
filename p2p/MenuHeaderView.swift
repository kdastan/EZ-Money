//
//  MenuHeaderView.swift
//  p2p
//
//  Created by Apple on 27.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

class MenuHeaderView: UIView {
    
    lazy var avatar: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "boy")
        image.contentMode = .center
        return image
    }()
    
    lazy var nameInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Камилла Н."
        label.numberOfLines = 0
        return label
    }()
    
    lazy var email: UILabel = {
        let label = UILabel()
        label.text = "@email.com"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fetchFromDB()
        
        setupView()
        setupConstraints()
    }
    
    func fetchFromDB() {
        
        let ref = Database.database().reference()
        let currentID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(currentID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.email.text = (value?["email"] as? String)!
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("userData").child(currentID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.nameInfoLabel.text = value?["name"] as? String ?? "Name Surname"
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        addSubview(avatar)
        addSubview(nameInfoLabel)
        addSubview(email)
    }
    
    func setupConstraints() {
        avatar <- [
            Size(48),
            Left(10),
            CenterY(0)
        ]
        
        nameInfoLabel <- [
            Top(0).to(avatar, .top),
            Left(10).to(avatar, .right),
            Height(25)
        ]
        
        email <- [
            Bottom(0).to(avatar, .bottom),
            Left(10).to(avatar, .right),
            Height(20)
        ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
