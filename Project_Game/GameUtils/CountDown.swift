//  Project_Game
//
//  Created by ruben mimoun on 10/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//
import Foundation
import SpriteKit


class CountDown : SKLabelNode {
    
    var endTime:Date!
    
    func update(){
        let timeLeftInteger = Int(timeLeft())
        fontSize = 40
        fontName = "Menlo-Bold"
        text = "Time left :" + String(timeLeftInteger)
    }
    
    func addTime(duration : TimeInterval){
        endTime.addTimeInterval(duration)
    }
    
    func startWithDuration(duration: TimeInterval){
        fontSize = 30
        let timeNow = Date();
        endTime = timeNow.addingTimeInterval(duration)
    }
    
    func hasFinished() -> Bool{
        
        return timeLeft() == 0;
    }
    
    private func timeLeft() -> TimeInterval{
        
        let now = Date();
        let remainingSeconds = endTime.timeIntervalSince(now)
        return max(remainingSeconds, 0)
    }
    
}



