//
//  ProgressView.swift
//  Project_Game
//
//  Created by sasha tobelaim on 04/05/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//
import PKHUD
import Foundation

class ProgressView{
    
    static let hud =  ProgressView()
    
    var progressHud : PKHUDProgressView?
    
    func setProgressView(title : String){
        progressHud =  PKHUDProgressView(title: title, subtitle: "Wait ... ")
        PKHUD.sharedHUD.contentView = progressHud!
        PKHUD.sharedHUD.show()
    }
    
    func closeProgressView(){
        PKHUD.sharedHUD.hide()
    }
    
}
