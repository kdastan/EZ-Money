//
//  userModel.swift
//  p2p
//
//  Created by Apple on 28.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import Foundation

struct userDataModel {
    
    var birthDate: String
    var birthPlace: String
    var dateOfIssue: String
    var homePhone: String
    var idNumber: String
    var iinNumber: String
    var issuingAuthority: String
    var mobilePhone: String
    var name: String
    var patronymic: String
    var surname: String
    var validatyDate: String
    
    init(birthDate: String, birthPlace: String, dateOfIssue: String, homePhone: String, idNumber: String, iinNumber: String, issuingAuthority: String, mobilePhone: String, name: String, patronymic: String, surname: String, validatyDate: String) {
        
        self.birthDate = birthDate
        self.birthPlace = birthPlace
        self.dateOfIssue = dateOfIssue
        self.homePhone = homePhone
        self.idNumber = idNumber
        self.iinNumber = iinNumber
        self.issuingAuthority = issuingAuthority
        self.mobilePhone = mobilePhone
        self.name = name
        self.patronymic = patronymic
        self.surname = surname
        self.validatyDate = validatyDate
        
    }
}
