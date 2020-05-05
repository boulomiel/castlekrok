//
//  ToolBarTextField.swift
//  TextFieldProject
//
//  Created by ruben mimoun on 09/02/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import UIKit

class ToolBarTextField: UITextField {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupToolBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupToolBar()
    }
    
    private func setupToolBar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width
            , height: 44))
        
        let buttonTitle : String  = self.returnKeyType == .next ? "Next" : "Done"
        
        let spaceButton =  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let actionButton = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(buttonPressed(_:)))
        
        toolbar.items = [spaceButton,actionButton]
        
        self.inputAccessoryView = toolbar
    }
    
    
    @objc func buttonPressed(_ sender : Any){
        
        self.sendActions(for: .editingDidEndOnExit)
        
    }
    
}
