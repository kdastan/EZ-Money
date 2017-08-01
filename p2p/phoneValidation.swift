//
//  phoneValidation.swift
//  p2p
//
//  Created by Apple on 01.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SwiftValidator

class phoneValidation: RegexRule {
    
    //static let regex = "\\d{10}"
    
    convenience init(message : String = "Попробуйте ввести номер заново"){
        self.init(regex: "\\d{10}", message : message)
    }
    
}
