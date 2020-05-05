//
//  Date.swift
//  Project_Game
//
//  Created by sasha tobelaim on 22/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import Foundation

class DateScore {
    
    static let shared = DateScore()
    
    
    func getDate() -> String{
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        // get the date time String from the date object
        return formatter.string(from: currentDateTime)
    }
    
}
