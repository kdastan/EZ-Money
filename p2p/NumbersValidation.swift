//
//  documentNumbersValidation.swift
//  p2p
//
//  Created by Apple on 01.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SwiftValidator

class NumbersValidation: RegexRule {
    
    convenience init(message : String = ""){
        self.init(regex: "^[1-9][0-9]*$", message : message)
    }
    
}
