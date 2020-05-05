//
//  TableCell.swift
//  Project_Game
//
//  Created by ruben mimoun on 17/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import UIKit

class HighScoreTableCell: UITableViewCell {
    
    var name : String?
    var mDate : String?
    var total : String?
    
    var properties : [String]?
    
    
    
    @IBOutlet weak var playerLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    func setup(player : String?, score : String?, date : String?){
        playerLabel.text = player!
        scoreLabel.text = score!
        dateLabel.text = date!
        
        
    }
    
    
    
}
