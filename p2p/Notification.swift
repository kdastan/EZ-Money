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
