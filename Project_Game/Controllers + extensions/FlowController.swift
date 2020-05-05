//
//  FlowController.swift
//  Project_Game
//
//  Created by ruben mimounon 15/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FlowController{
    
    weak var window : UIWindow?
    
    static let shared = FlowController()
    
    var vc : UIViewController!
    
    private var didLogin : Bool {
        return FirebaseManager.manager.userId != nil
        
    }
    
    func determineRoot(){
        
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                FlowController.shared.determineRoot()
            }
            return
            
        }
        
        vc = UIStoryboard(name: didLogin ? "Menu" : "Login", bundle: nil).instantiateInitialViewController()
        
        print(didLogin)
        self.window?.rootViewController? = vc
        
        
    }
    
    
}
