//
//  LendViewController.swift
//  p2p
//
//  Created by Apple on 02.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase

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
        
        let ref = Database.database().reference()
        //let uid = Auth.auth().currentUser?.uid
        
        let newRef = ref.child("investorRequests").childByAutoId()
        
        guard let money = container.container.investmentField.textField.text, let percent = container.container.percentField.textField.text, let period = container.container.periodField.textField.text, let uid = Auth.auth().currentUser?.uid else { return }
        
        let post: [String: Any] = [
            "amount": money,
            "date": currentDate(),
            "id": newRef.key,
            "investorId": uid,
            "rate": percent,
            "time": period
        ]
        
        newRef.setValue(post)
        
    }
    
    func currentDate() -> String {
        let data = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/YYYY"
        let result = formatter.string(from: data)
        return result
    }
    
}
