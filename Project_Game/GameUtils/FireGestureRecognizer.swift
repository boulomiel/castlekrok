//
//  FireGestureRecognizer.swift
//  Project_Game
//
//  Created by ruben mimoun on 10/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import Foundation
import SceneKit

class FireGestureRecognizer: UIGestureRecognizer {
    
    var timeThreshold = 0.15
    var distanceThreshold = 5.0
    private var startTimes = [Int:TimeInterval]()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch in touches {
            startTimes[touch.hash] = touch.timestamp
        }
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        for touch in touches {
            
            let newPos = touch.location(in: view)
            let oldPos = touch.previousLocation(in: view)
            // calculation of the difference between the two positions of the entry and exit touch
            let distanceDelta = Double(max(abs(newPos.x - oldPos.x), abs(newPos.y - oldPos.y)))
            if distanceDelta >= distanceThreshold {
                startTimes[touch.hash] = nil
            }
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        
        for touch in touches {
            
            let startTime = startTimes[touch.hash]
            if let startTime = startTime {
                //check if within time
                let timeDelta = touch.timestamp - startTime
                //check length of touch according to the reference saved in the arrayt
                if timeDelta < timeThreshold {
                    //recognized
                    state = .ended
                }
            }
        }
        reset()
    }
    
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        reset()
    }
    
    override func reset() {
        
        if state == .possible {
            state = .failed
        }
    }
}
