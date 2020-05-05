//
//  LoginViewController.swift
//  Project_Game
//
//  Created by ruben mimoun on 15/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

@available(iOS 13.0, *)
class LoginViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var email: ToolBarTextField!
    @IBOutlet weak var password : ToolBarTextField!
    @IBOutlet weak var stackViewTopLayout: NSLayoutConstraint!
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()        
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        guard let password = password.text , password.count > 0,
            let email = email.text, email.count > 0 else{
                return
        }
        
        ProgressView.hud.setProgressView(title: "Signing you in")
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard self != nil else { return }
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action : UIAlertAction) in
                    self!.performSegue(withIdentifier: "register", sender: nil)
                }))
                ProgressView.hud.closeProgressView()
                self!.present(alert, animated: true)
                return
            }
            ProgressView.hud.closeProgressView()
            FlowController.shared.determineRoot()
            
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
        stackViewTopLayout.constant = 16
        UIView.animate(withDuration: 1) {
            self.view.layoutSubviews()
        }
    }
    
    @objc func handleKeyboardShow(_ notification : Notification){
        
        // makes sure we get the desired value from the keyboard, or leave
        guard let value =  notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else{
            return
        }
        let textField = stackView.arrangedSubviews.filter{$0.isFirstResponder}[0]
        let height = value.cgRectValue.height
        let y =  max(textField.frame.origin.y * 1.5 - height,0)
        
        stackViewTopLayout.constant = 16 - y
        
        UIView.animate(withDuration: 1) {
            self.view.layoutSubviews()
        }
    }
    
    
    @IBAction func didEndOnExit(_ sender: UITextField) {
        
        
        if let nextTextField = self.view.viewWithTag(sender.tag + 1) as? UITextField{
            nextTextField.becomeFirstResponder()
        }else{
            sender.resignFirstResponder()
        }
        
    }
    
    
    @IBAction func tapAction(_ sender: Any) {
        
        self.view.endEditing(true)
    }
}

