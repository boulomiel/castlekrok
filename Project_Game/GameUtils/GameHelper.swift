
//  Project_Game
//
//  Created by ruben mimoun on 10/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

public enum GameStateType {
    case playing
    case tapToPlay
    case gameOver
}

class GameHelper {
    
    var coinsBanked:Int
    var coinsCollected:Int
    var state = GameStateType.tapToPlay
    
    var hudNode:SCNNode!
    var labelNode:SKLabelNode!
    
    
    static let sharedInstance = GameHelper()
    
    var sounds:[String:SCNAudioSource] = [:]
    
    private init() {
        coinsCollected = 0
        coinsBanked = 0
    }
    
    
    func loadSound(name:String, fileNamed:String) {
        if let sound = SCNAudioSource(fileNamed: fileNamed) {
            sound.isPositional = false
            sound.volume = 0.3
            sound.load()
            sounds[name] = sound
        }
    }
    
    func playSound(node:SCNNode, name:String) {
        let sound = sounds[name]
        node.runAction(SCNAction.playAudio(sound!, waitForCompletion: false))
    }
    
    func collectCoin() {
        coinsCollected += 1
    }
    
    func bankCoins() -> Bool {
        coinsBanked += coinsCollected
        
        if coinsCollected > 0 {
            coinsCollected = 0
            return true
        }
        
        return false
    }
    
    func reset() {
        coinsCollected = 0
        coinsBanked = 0
    }
}
