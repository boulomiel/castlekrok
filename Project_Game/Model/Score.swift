//
//  Scores.swift
//  Project_Game
//
//  Created by ruben mimoun on 15/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import Foundation
import Firebase

struct Score  {
    
    
    let id : String
    let score : Int
    let player : String
    let date : String
    
    init(uid : String, uName : String, score : Int , date : String){
        
        self.id = UUID().uuidString
        self.player =  uName
        self.score =  score
        self.date = date
        
    }
    
    init?(_ dict : [String : Any] ){
        guard let id =  dict["id"] as? String,
            let player = dict["player"] as? String,
            let score =  dict["score"] as? Int,
            let createdAt =  dict["date"] as? String else {
                return nil
        }
        
        self.id = id
        self.player = player
        self.score =  score
        self.date =  createdAt
    }
    
    
    var dictionnaryRepresentation : [String : Any]{
        return [
            "id": id ,
            "player" : player ,
            "score" : score,
            "date" : date
        ]
    }
    
    
    
}
