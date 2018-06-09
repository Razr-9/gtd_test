//
//  AppDelegate.swift
//  gtd_test
//
//  Created by 聂润泽 on 2018/1/12.
//  Copyright © 2018年 Razr. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //MARK: ------------ IQKeyboardManager
        let manager =  IQKeyboardManager.shared
        manager.enable = true
        manager.shouldResignOnTouchOutside = true//控制点击背景是否收起键盘
        manager.enableAutoToolbar = false //控制是否显示键盘上的工具栏
        
        // Override point for customization after application launch.
      
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })

        if UserDefaults.standard.bool(forKey: "isFirstLaunch") == false {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let VC = sb.instantiateViewController(withIdentifier: "FirstLaunchViewController")
            self.window?.rootViewController = VC
            self.window?.makeKeyAndVisible()
        }else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let VC = sb.instantiateViewController(withIdentifier: "navigation")
            self.window?.rootViewController = VC
            self.window?.makeKeyAndVisible()
        }
        
        return true
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

