//
//  AppDelegate.swift
//  p2p
//
//  Created by Apple on 24.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RESideMenu
import Firebase
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var isLogged = false
    var isInvestor = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        cordinateAppFlow()
        IQKeyboardManager.sharedManager().enable = true
        
        print(InstanceID.instanceID().token())
        let token = Messaging.messaging().fcmToken
        
        print("token - \(token)")
        
        return true
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    /// This method will be called whenever FCM receives a new, default FCM token for your
    /// Firebase project's Sender ID.
    /// You can send this token to your application server to send notifications to this device.
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        ref.child("users").child("\(uid)").child("token").setValue(fcmToken)
    }
    
    func cordinateAppFlow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if isLogged {
            let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            let navigationController = BorrowViewController(rootViewController: pageController)
            
            //let a = UINavigationController(rootViewController: MenuViewController())
            
            let sideMenu = RESideMenu(contentViewController: navigationController, leftMenuViewController: MenuViewController(), rightMenuViewController: nil)
            sideMenu?.backgroundImage = UIImage(named: "sample")
            
            window?.rootViewController = sideMenu
        } else {
            let loginController = UINavigationController(rootViewController: LoginViewController())
            window?.rootViewController = loginController
        }
        window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    

}

