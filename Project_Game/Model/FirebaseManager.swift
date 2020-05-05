//
//  FirebaseManager.swift
//  Project_Game
//
//  Created by ruben mimoun on 15/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FirebaseManager{
    
    static let manager =  FirebaseManager()
    
    var userId : String? {
        return Auth.auth().currentUser?.uid
    }
    
    var userName : String? {
        return Auth.auth().currentUser?.displayName
    }
    
    private lazy var databaseReference : DatabaseReference = {
        return  Database.database().reference().child("Game")
    }()
    
    
    func getAllScores(with completion: @escaping([Score])-> Void){
        ProgressView.hud.setProgressView(title: "Loading Scores")
        databaseReference.observeSingleEvent(of: .value) { (snapshot) in
            guard let  json = snapshot.value as? [String : Any] else {
                completion([])
                return
            }
            
            let result : [Score] = Array(json.values).compactMap{$0 as? [String:Any] }.compactMap{
                Score($0)}
            
            ProgressView.hud.closeProgressView()
            completion(result)
        }
        
    }
    
    
    
    func addNewScore(with score : Int){
        
        guard let uid = self.userId,
            let uname = self.userName else {
                return
        }
        
        let date = DateScore.shared.getDate()
        
        let newScore = Score(uid: uid, uName: uname,score: score, date : date)
        ProgressView.hud.setProgressView(title: "Uploading Scores")
        databaseReference.child(uid).setValue(newScore.dictionnaryRepresentation)
        ProgressView.hud.closeProgressView()
        
    }
    
    
    
    
    
    
}

