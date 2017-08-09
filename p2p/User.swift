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
    
    static var investorObserverId: UInt?
    
    static func fetchInvestor(request: String, compleation: @escaping (String?, String?, String?, String?, String?, String?) -> Void) {
        let newRef = Database.database().reference()
        
        if let id = investorObserverId {
            newRef.child("\(request)").queryOrderedByKey().removeObserver(withHandle: id)
        }
        investorObserverId = newRef.child("\(request)").queryOrderedByKey().observe(.childAdded, with: { snapshot in
        let value = snapshot.value as? [String: String]
        compleation(value?["amount"], value?["date"], value?["id"], value?["investorId"], value?["rate"], value?["time"])
        })
    }
    
    static var observerId: UInt?
    
    static func fetchRequests(fetchChild: String, compleation: @escaping (String?, String?, String?, String?, Int?) -> Void) {
        let ref = Database.database().reference().child("\(fetchChild)")
        let uid = Auth.auth().currentUser?.uid
        if let id = observerId {
            ref.queryOrdered(byChild: "borrowerId").queryEqual(toValue: uid).removeObserver(withHandle: id)
        }
        observerId = ref.queryOrdered(byChild: "borrowerId").queryEqual(toValue: uid).observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            compleation(value?["bigId"] as? String, value?["borrowerAmount"] as? String, value?["borrowerId"] as? String, value?["requestId"] as? String, value?["status"] as? Int)
        })
    }
    
    static var requestObserverId: UInt?
    
    static func fetchRequestID(fetchChild: String, completion: @escaping (String?, String?, String?) -> Void){
        let ref = Database.database().reference().child("\(fetchChild)")
        let uid = Auth.auth().currentUser?.uid
        
        if let id = requestObserverId {
            ref.queryOrdered(byChild: "investorId").queryEqual(toValue: uid).removeObserver(withHandle: id)
        }
        
        requestObserverId = ref.queryOrdered(byChild: "investorId").queryEqual(toValue: uid).observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            completion(value?["id"] as? String, value?["rate"] as? String, value?["time"] as? String)
        })
    }
    
    static var allRequestObserverId: UInt?
    
    static func fetchAllRequests(fetchChild: String, completion: @escaping (String?, Int?, String?) -> Void) {
        let ref = Database.database().reference().child("allRequests")
        
        if let id = allRequestObserverId {
            ref.queryOrdered(byChild: "requestId").queryEqual(toValue: fetchChild).removeObserver(withHandle: id)
        }
        
        allRequestObserverId = ref.queryOrdered(byChild: "requestId").queryEqual(toValue: fetchChild).observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            completion(value?["borrowerId"] as? String, value?["status"] as? Int, value?["bigId"] as? String)
        })
    }
    
    static func setRequestStatus(requestId: String, status: Int, compleation: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference().child("allRequests").child("\(requestId)").child("status")
        ref.setValue(status)
        compleation(true)
    }
    
    static func fetchUserEmail(uid: String, compleation: @escaping (String?, String?) -> Void){
        let ref = Database.database().reference().child("users")
        ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            compleation(value?["email"] as? String, value?["token"] as? String)
        }) {(error) in
            print(error.localizedDescription)
        }
    }
    
    static func setInvestorFinance(uid: String, amount: String, compleation: @escaping (Bool?) -> Void) {
        let newAmount = Int(amount)
        let ref = Database.database().reference().child("users").child("\(uid)").child("balance")
        ref.setValue(newAmount)
        compleation(true)
    }
    
    static func fetchUsers(uid: String, compleation: @escaping (Int?, String?, Bool?, String?, Bool?) -> Void){
        let ref = Database.database().reference().child("users")
        ref.child("\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            compleation(value?["balance"] as? Int, value?["email"] as? String, value?["isInvestor"] as? Bool, value?["token"] as? String, value?["userData"] as? Bool)
        })
    }
}
