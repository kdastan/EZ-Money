//
//  userCardValidation.swift
//  p2p
//
//  Created by Apple on 10.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SwiftValidator

class userCardValidation: RegexRule {
    convenience init(message : String = "Попробуйте ввести номер заново"){
        self.init(regex: "\\d{3}|\\d{16}", message : message)
    }
    
}
