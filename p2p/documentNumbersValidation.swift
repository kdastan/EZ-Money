//
//  documentNumbersValidation.swift
//  p2p
//
//  Created by Apple on 01.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SwiftValidator

class documentNumbersValidation: RegexRule {
    
    convenience init(message : String = "Попробуйте ввести информацию о документе заново"){
        self.init(regex: "\\d{9}|\\d{12}", message : message)
    }
    
}
