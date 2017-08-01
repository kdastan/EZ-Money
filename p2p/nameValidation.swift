//
//  nameValidation.swift
//  p2p
//
//  Created by Apple on 01.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SwiftValidator

class SSNVRule: RegexRule {
    
    static let regex = "[А-я]+"
    
    convenience init(message : String = "Попробуйте заполнить поле заново"){
        self.init(regex: SSNVRule.regex, message : message)
    }
    
}
