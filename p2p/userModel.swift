//
//  userModel.swift
//  p2p
//
//  Created by Apple on 28.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import Foundation

struct userModel {
    
    var balance: Int
    var email: String
    var isInvestor: Bool
    var password: String
    var token: String
    var userData: Bool
    
    init(balance: Int, email: String, isInvestor: Bool, password: String, token: String, userData: Bool) {
        
        self.balance = balance
        self.email = email
        self.isInvestor = isInvestor
        self.password = password
        self.token = token
        self.userData = userData
        
    }
    
}
