//
//  User.swift
//  p2p
//
//  Created by Apple on 02.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class User {

    static func fetchUserName(uid: String, completion: @escaping (String?, String?) -> Void) {
        let refUsers = Database.database().reference().child("userData")
        refUsers.child("\(uid)").observeSingleEvent(of: .value, with: { snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                completion(nil, nil)
                return
            }
            completion(dict["name"] as? String, dict["surname"] as? String)
        })
    }
    
}
