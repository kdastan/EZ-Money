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
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Получить займ", for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var requestButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Запросить всех", for: .normal)
        button.isHidden = true
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var investorSearchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Найти инвестора", for: .normal)
        button.isHidden = true
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = NSTextAlignment.center
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(investorSearch), for: .touchUpInside)
        return button
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "10 подходящих вариантов"
        label.isHidden = true
        label.textColor = .white
        label.font = UIFont(name: "Helvetica", size: 20)
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.isHidden = true
        searchBar.barTintColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1)
        searchBar.placeholder = "Введите имя"
        searchBar.layer.borderColor = UIColor(colorLiteralRed: 70/255, green: 161/255, blue: 213/255, alpha: 1).cgColor
        searchBar.layer.borderWidth = 1
        searchBar.tintColor = .white
//        searchBar.
        searchBar.setValue("Отмена", forKey: "cancelButtonText")
        return searchBar
    }()
    
    func investorSearch() {
        searchBar.isHidden = false
        requestButton.isHidden = true
        investorSearchButton.isHidden = true
        print("Hello")
    }
    
    func pressed() {
        button.isHidden = true
        requestButton.isHidden = false
        investorSearchButton.isHidden = false
        label.isHidden = false
        
        let ref = Database.database().reference()
        let auth = Auth.auth().currentUser?.uid
        
        ref.child("users").child(auth!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let isData = value?["isInvestor"] as? Bool
            
            if isData! {
                print(isData!)
            } else {
                print(isData!)
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
        //asdasdASdasdasdasdasdasdasdassadasd
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(container)
        
        [button, requestButton, investorSearchButton, label, searchBar].forEach{
            container.addSubview($0)
        }
        
        searchBar.delegate = self
    
        
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
        
        button <- [
            CenterX(0),
            Top(25).to(container.field2, .bottom),
            Width(180),
            Height(50)
        ]
        
        label <- [
            CenterX(0),
            Bottom(0).to(button, .top),
            Height(25)
        ]
        
        searchBar <- [
            Top(15).to(button, .top),
            CenterX(0),
            Height(50),
            Width(sizeX-10)
        ]
        
        requestButton <- [
            Top(15).to(button, .top),
            Width(newSizeX),
            Height(50),
            Left(10)
        ]
        
        investorSearchButton <- [
            Top(15).to(button, .top),
            Width(newSizeX),
            Height(50),
            Right(10)
        ]
    }
    
}

extension Container: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchBar.isHidden = true
        
        requestButton.isHidden = false
        investorSearchButton.isHidden = false
    }

}
