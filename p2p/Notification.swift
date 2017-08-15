//
//  Notification.swift
//  p2p
//
//  Created by Apple on 15.08.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class Notification {
    
    enum notificationMessage: String {
        case request = "Вам поступил запрос на инвестирование, ответить на него можете в личном кабинете"
        case accept = "Ваш запрос принят инвестором, ожидаем оформления"
        case reject = "Инвестор не принял ваш запрос"
        case issue = "Вам поступили деньги, проверить баланс вы можете в своем личном кабинете"
    }
    
    enum notificationTitle: String {
        case request = "Новый запрос"
        case accept = "Запрос принят"
        case reject = "Отказано"
        case issue = "Запрос оформлен"
    }
    
    enum notificationRecord: String {
        case requset = "новый запрос на деньги"
        case accept = "принял запрос"
        case reject = "отклонил запрос"
        case issue = "оформил запрос"
    }
    
    static func sendNotification(investorToken: String, title: notificationTitle, message: notificationMessage, id: String, recordType: notificationRecord) {
    
        let reference = Database.database().reference()
        let notifRecord = reference.child("notifications").childByAutoId()
        guard let uid = Auth.auth().currentUser?.uid else {return}
//
//        
//        let notificationUrl = "https://fcm.googleapis.com/fcm/send"
//        let serverKey = "AAAAiyp0u8w:APA91bEuiQ--qrKwl_ahYWvr0qbs30gN55XT-U5XNq2ptO_pznUyjSaYXwEFz1SK1pKyxcBIE7Y9ALxLj5gXjNCioqzre7jSNA8gG0Xu_YskTsX5HS1s6I527FXcc8lFz6dgF892jhr8"
//        
//        
//        let token = investorToken
//
//        var header: HTTPHeaders? = HTTPHeaders()
//        header = [
//            "Content-Type":"application/json",
//            "Authorization":"key=\(serverKey)"
//        ]
//        let notificationParameter: Parameters? = [
//            "notification": [
//                "title": title.rawValue,
//                "body": message.rawValue
//            ],
//            "to" : "\(token)"
//        ]
//        
//        Alamofire.request(notificationUrl as URLConvertible, method: .post as HTTPMethod, parameters: notificationParameter, encoding: JSONEncoding.default, headers: header!).responseJSON { (resp) in
//            print(resp)
//        }
        
        User.fetchUserEmail(uid: uid, compleation: { (email, token) in
            let message = "\(email!) \(recordType.rawValue)"
            var post = [
                "from":uid,
                "message": message,
                "to":id
            ]
            notifRecord.setValue(post)
        })
    }
    
}
