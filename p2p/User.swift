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
    // var name

//    static func signUp(withEmail email: String, withPassword password: String, and post: [String: Any], completion: @escaping ((User?, Error)->Void)) {
//        Auth.auth().createUser(withEmail: email, password: password){ (user, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("You successfuly registered")
//                guard let uid = Auth.auth().currentUser?.uid else {return}
//                let ref = Database.database().reference()
//                ref.child("users").child("\(uid)").setValue(post)
//                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                    appDelegate.isLogged = true
//                    appDelegate.cordinateAppFlow()
//                }
//            }
//        }
//    }
}
