//
//  RegisterViewController.swift
//  Project_Game
//
//  Created ruben mimoun on 15/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class RegisterViewController : UIViewController{
    
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackTopLayout: NSLayoutConstraint!
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePass: UITextField!
    let ref =  Database.database().reference()
    
    private var authCheck : AuthChecker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.becomeFirstResponder()
        authCheck = AuthChecker(mView: self)
    }
    
    
    
    @IBAction func registerAction(_ sender: UIButton) {
        guard let email = email.text, email.count > 0,
            let nickname = nickName.text, nickname.count > 0,
            let password = password.text, password.count > 0,
            let retypePass = retypePass.text, retypePass.count > 0
            else {
                return
        }
        
        let emailChecked : Bool = authCheck!.checkEmail(email: email)
        let checkNickName : Bool = authCheck!.checkNickname(nickname: nickname)
        let checkPassword : Bool = authCheck!.checkPasswords(firstPass: password, secondPass: retypePass)
        
        if( !emailChecked &&
            !checkNickName &&
            !checkPassword){
            return
        }
        
        sender.isEnabled = false
        ProgressView.hud.setProgressView(title: "Registering")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                
                let alert =  UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                sender.isEnabled = true
                return
            }
            
            let request = result!.user.createProfileChangeRequest()
            request.displayName = nickname
            ProgressView.hud.closeProgressView()
            request.commitChanges { (commitError) in
                FlowController.shared.determineRoot()
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardHide(_ notification : Notification){
        stackTopLayout.constant = 16
        UIView.animate(withDuration: 1) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func handleKeyboardShow(_ notification : Notification){
        
        guard let value =  notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else{
            return
        }
        
        let textField = stackView.arrangedSubviews.filter{$0.isFirstResponder}[0]
        let height = value.cgRectValue.height
        let y =  max(textField.frame.origin.y * 1.5 - height,0)
        stackTopLayout.constant = 16 - y
        
        UIView.animate(withDuration: 1) {
            self.view.layoutSubviews()
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func didEndOnExit(_ sender: ToolBarTextField) {
        if let nextTextField = self.view.viewWithTag(sender.tag + 1) as? ToolBarTextField{
            nextTextField.becomeFirstResponder()
        }else{
            sender.resignFirstResponder()
        }
    }
    
    
}
