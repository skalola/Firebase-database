//
//  AppDelegate.swift
//  FirebaseData
//
//  Created by Shiv Kalola on 6/20/18.
//  Copyright © 2018 Shiv Kalola. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        // Firebase Init
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
//            FIRApp.configure()
//            FIRDatabase.database().persistenceEnabled = true
            return true
    }
}   
