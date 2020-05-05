//
//  AppDelegate.swift
//  Project_Game
//
//  Created by sasha tobelaim on 08/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
//        FlowController.shared.window = window
//        FlowController.shared.determineRoot()
//        self.window?.makeKeyAndVisible()
        
        return true
    }




}

