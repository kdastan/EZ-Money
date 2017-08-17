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
        
        ref.queryOrdered(byChild: "borrowerId").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else{
                print("User doesn't exist")
                compleation(nil, nil, nil, nil, nil)
                return
            }
            observerId = ref.queryOrdered(byChild: "borrowerId").queryEqual(toValue: uid).observe(.childAdded, with: { (snapshot) in
                let value = snapshot.value as? [String: Any]
                compleation(value?["bigId"] as? String, value?["borrowerAmount"] as? String, value?["borrowerId"] as? String, value?["requestId"] as? String, value?["status"] as? Int)
            })
        })
    }
    
    static var requestObserverId: UInt?
    
    static func fetchRequestID(fetchChild: String, completion: @escaping (String?, String?, String?) -> Void){
        let ref = Database.database().reference().child("\(fetchChild)")
        let uid = Auth.auth().currentUser?.uid
        if let id = requestObserverId {
            ref.queryOrdered(byChild: "investorId").queryEqual(toValue: uid).removeObserver(withHandle: id)
        }
        
        ref.queryOrdered(byChild: "investorId").queryEqual(toValue: uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else{
                print("User doesn't exist")
                completion(nil, nil, nil)
                return
            }
            
            requestObserverId = ref.queryOrdered(byChild: "investorId").queryEqual(toValue: uid).observe(.childAdded, with: { (snapshot) in
                print(snapshot)
                
                let value = snapshot.value as? [String: Any]
                print(value?["id"] as? String)
                
                completion(value?["id"] as? String, value?["rate"] as? String, value?["time"] as? String)
            })
        })
    }
    
    static var allRequestObserverId: UInt?
    
    static func fetchAllRequests(fetchChild: String, completion: @escaping (String?, Int?, String?, String?) -> Void) {
        let ref = Database.database().reference().child("allRequests")
        
        if let id = allRequestObserverId {
            ref.queryOrdered(byChild: "requestId").queryEqual(toValue: fetchChild).removeObserver(withHandle: id)
        }
        
        allRequestObserverId = ref.queryOrdered(byChild: "requestId").queryEqual(toValue: fetchChild).observe(.childAdded, with: { (snapshot) in
            
            guard snapshot.exists() else{
                print("User doesn't exist")
                completion(nil, nil, nil, nil)
                return
            }
            
            print(snapshot)
            let value = snapshot.value as? [String: Any]
            completion(value?["borrowerId"] as? String, value?["status"] as? Int, value?["bigId"] as? String, value?["borrowerAmount"] as? String)
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
    
    static func setInvestorFinance(uid: String, amount: Int, compleation: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference().child("users").child("\(uid)").child("balance")
        ref.setValue(amount)
        compleation(true)
    }
    
    static func setUserPassword(uid: String, password: String, compleation: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference().child("users").child("\(uid)").child("password")
        ref.setValue(password)
        compleation(true)
    }
    
    static func fetchUsers(uid: String, compleation: @escaping (Int?, String?, Bool?, String?, Bool?, String?) -> Void){
        let ref = Database.database().reference().child("users")
        ref.child("\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            compleation(value?["balance"] as? Int, value?["email"] as? String, value?["isInvestor"] as? Bool, value?["token"] as? String, value?["userData"] as? Bool, value?["password"] as? String)
        })
    }
    
    static func fetchInvestorExisting(uid: String, compleation: @escaping (String?) -> Void) {
        let ref = Database.database().reference().child("allRequests")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else{
                compleation(nil)
                return
            }
            compleation("exist")
        })
    }
    
    static func fetchAllRequestExisting(uid: String, compleation: @escaping (String?) -> Void) {
        let ref = Database.database().reference().child("investorRequests")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else{
                compleation(nil)
                return
            }
            compleation("exist")
        })
        
    }
    
    static func fetchForInvestorsAmount(uid: String, compleation: @escaping (Int?) -> Void) {
        let ref = Database.database().reference().child("users").child("\(uid)")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            compleation(value?["balance"] as? Int)
        })
    
    }
    
    static func successTransactionForInvestor(amount: Int, uid: String, compleation: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference().child("users").child("\(uid)").child("balance")
        ref.setValue(amount)
        compleation(true)
    }
    
    static func successTransactionForBorrower(amount: Int, uid: String, compleation: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference().child("users").child("\(uid)").child("balance")
        ref.setValue(amount)
        compleation(true)
    }
    
    static func borrowerBalance(uid: String, compleation: @escaping (Int?, String?) -> Void) {
        let ref = Database.database().reference().child("users").child("\(uid)")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            compleation(value?["balance"] as? Int, value?["token"] as? String)
        })
    
    }
    
    //MARK: Fetch - confirmation - userData filled
    static func fetchUserData(uid: String, compleation: @escaping (Bool?) -> Void){
        let ref = Database.database().reference().child("users")
        
        ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                compleation(nil)
                return
            }
            compleation(value["userData"] as? Bool)
        })
    }
    
    
    static func fetchallReq(id: String, completion: @escaping (Bool?) -> Void){
        let ref = Database.database().reference().child("allRequests")
        ref.queryOrdered(byChild: "requestId").queryEqual(toValue: id).observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else {
                print("User doesn't exist")
                completion(nil)
                return
            }
            completion(true)
        })
        
        
       
    }
    
    
    
    
}
