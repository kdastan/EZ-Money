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

struct Allrequests {
    let bigId: String!
    let borrowerAmount: String!
    let borrowerId: String!
    let requestId: String!
    let status: Int!
}

class User {
    
    var userNameAndSurname = ""

    static func fetchUserName(uid: String, completion: @escaping (String?, String?, String?) -> Void) {
        let refUsers = Database.database().reference().child("userData")
        refUsers.child("\(uid)").observeSingleEvent(of: .value, with: { snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                completion(nil, nil, nil)
                return
            }
            completion(dict["name"] as? String, dict["surname"] as? String, dict["patronymic"] as? String)
        })
    }
   
    static func fetchRequestId(requestId: String, completion: @escaping (String?, String?, String?) -> Void) {
        let ref = Database.database().reference().child("investorRequests")
        ref.child("\(requestId)").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil, nil, nil)
                return
            }
            completion(value["investorId"] as? String, value["rate"] as? String, value["time"] as? String)
        })
    }
    
    static func fetchInvestor(request: String, compleation: @escaping (String?, String?, String?, String?, String?, String?) -> Void) {
        let newRef = Database.database().reference()
        newRef.child("\(request)").queryOrderedByKey().observe(.childAdded, with: { snapshot in
    
        let value = snapshot.value as? [String: String]
        let amount = value?["amount"]
        let date = value?["date"]
        let id = value?["id"]
        let investorId = value?["investorId"]
        let rate = value?["rate"]
        let time = value?["time"]
    
        compleation(amount, date, id, investorId, rate, time)
        })
    }
    
    static func fetchRequests(fetchChild: String, compleation: @escaping (String?, String?, String?, String?, Int?) -> Void) {
        let ref = Database.database().reference().child("\(fetchChild)")
        let uid = Auth.auth().currentUser?.uid
        
        ref.queryOrdered(byChild: "borrowerId").queryEqual(toValue: uid).observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            compleation(value?["bigId"] as? String, value?["borrowerAmount"] as? String, value?["borrowerId"] as? String, value?["requestId"] as? String, value?["status"] as? Int)
        })
    }
    
    
    

}
