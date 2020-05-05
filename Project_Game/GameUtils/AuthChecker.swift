//
//  AuthChecker.swift
//  Project_Game
//
//  Created by sasha tobelaim on 04/05/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import Foundation
import UIKit

class AuthChecker {
    
    var view : UIViewController?
    var nick : String?
    var mMail : String?
    
    init(mView : UIViewController) {
        self.view = mView
    }
    
    func checkEmail(email : String?) -> Bool{
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        var emptyMail : Bool {
            email!.isEmpty
        }
        
        if !emptyMail {
            
            if(emailPredicate.evaluate(with: email!)){
                return true
            }else {
                createAlert(title: "Email is not valid", message: "Insert a valid email ", view: self.view!)
                return false
            }
            
        }else{
            createAlert(title: "Email is not valid", message: "Email field is empty", view: self.view!)
            return false
        }
        
        
    }
    
    func checkNickname(nickname : String?) -> Bool{
        
        var boolName : Bool{
            nickname!.count > 0
        }
        
        if !boolName {
            createAlert(title: "Nickname not valid", message: "it should be longer than 3 characters", view: self.view!)
            return false
        }
        return true
    }
    
    func checkPasswords( firstPass : String?, secondPass : String?) -> Bool{
        
        var goodFirst : Bool { !firstPass!.isEmpty}
        var longEnough : Bool { firstPass!.count > 5}
        
        if !goodFirst{
            createAlert(title:"Password invalid" , message: "Your password is not long enough", view: self.view!)
            return false
        }
        
        if !longEnough {
            createAlert(title:"Password invalid" , message: "Your password is not long enough", view: self.view!)
            return false
        }
        
        if secondPass != firstPass {
            createAlert(title: "Passwords don't match", message: "Please make sure both your password are identical", view: self.view!)
            return false
        }
        
        return true
    }
    
    
    
    
    func createAlert(title : String, message : String, view : UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action : UIAlertAction) in
        }))
        view.present(alert, animated: true)
    }
    
}
