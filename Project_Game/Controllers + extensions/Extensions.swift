//
//  RendererDelegate.swift
//  Project_Game
//
//  Created by ruben mimoun 08/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import Foundation
import SceneKit
import UIKit


extension GameController : SCNSceneRendererDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard game.state == .playing else {return}
        
        kingPos = kingCrokNode.position
        
        addTimeGraphic()
        countDown.update()
        labelNode.text = "Score : \(score)"
        updatePositions()
        speedUpgrade()
        
        if max < 0 {
            
            restartGame()
            
        }
        
        
        if countDown.hasFinished(){
            restartGame()
        }
        
        
        let translation = walkGesture.translation(in: self.view)
        
        let angle = heroNode.presentation.rotation.w * heroNode.presentation.rotation.y
        
        var impulse = SCNVector3(x: Swift.max(-1, min(1, Float(translation.x) / 50)), y: 0, z: Swift.max(-1, min(1, Float(-translation.y) / 50)))
        
        impulse = SCNVector3(
            x: impulse.x * cos(angle) - impulse.z * sin(angle),
            y: impulse.y * cos(angle) - impulse.z * sin(angle),
            z: impulse.x * -sin(angle) - impulse.z * cos(angle)
        )
        heroNode.physicsBody?.applyForce(impulse, asImpulse: true)
        
        
        
        
        //handle firing
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastTappedFire < autofireTapTimeThreshold {
            let fireRate = min(Double(maxRoundsPerSecond), Double(tapCount) / autofireTapTimeThreshold)
            if now - lastFired > 1 / fireRate {
                
                let angle = heroNode.presentation.rotation.w * heroNode.presentation.rotation.y
                var direction = SCNVector3(x: -sin(angle), y: 0, z: -cos(angle))
                
                direction = SCNVector3(x: cos(elevation) * direction.x, y: sin(elevation), z: cos(elevation) * direction.z)
                
                //create or recycle bullet node
                bulletNode = {
                    if self.bullets.count < self.maxBullets {
                        return SCNNode()
                    } else {
                        return self.bullets.remove(at: 0)
                    }
                }()
                
                
                bullets.append(bulletNode)
                bulletNode.geometry = SCNBox(width: CGFloat(bulletRadius) * 2, height: CGFloat(bulletRadius) * 2, length: CGFloat(bulletRadius) * 2, chamferRadius: CGFloat(bulletRadius))
                bulletNode.position = SCNVector3(x: heroNode.presentation.position.x, y: 1.4, z: heroNode.presentation.position.z)
                bulletNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: bulletNode.geometry!, options: nil))
                bulletNode.castsShadow = true
                bulletNode.physicsBody?.categoryBitMask = CollisionCategory.Bullet
                bulletNode.name = "Bullet"
                bulletNode.physicsBody?.contactTestBitMask = CollisionCategory.Monster | CollisionCategory.Castle
                bulletNode.physicsBody?.velocityFactor = SCNVector3(x: 1, y: 0.5, z: 1)
                self.sceneView.scene!.rootNode.addChildNode(bulletNode)
                
                //apply impulse
                let impulse = SCNVector3(x: direction.x * Float(bulletImpulse), y: direction.y * Float(bulletImpulse), z: direction.z * Float(bulletImpulse))
                bulletNode.physicsBody?.applyForce(impulse, asImpulse: true)
                
                
                //update timestamp
                lastFired = now
                game.playSound(node: bulletNode, name: "gun")
                if bulletNode.position.z == scoreBoard.position.z {bulletNode.isHidden = true}
            }
        }
        
        
    }
    
}

extension GameController : SCNPhysicsContactDelegate{
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        
        guard game.state == .playing else{ return}
        
        
        if (contact.nodeA.name == "pig" && contact.nodeB.name == "Bullet") ||
            (contact.nodeB.name == "pig" && contact.nodeA.name == "Bullet"){
            
            game.playSound(node: pigNode, name: "pigDead")
            addTime(node: pigNode)
            addTimeGraphic()
            
            
            let smoke = createSmoke( geometry: pigNode.geometry!)
            pigNode.addParticleSystem(smoke)
            pigNode.isHidden = true
            bulletNode.isHidden = true
            pigNode.position.z = -50
            pigNode.isHidden = false
            updateScore(node: pigNode)
            
        }
        
        if (contact.nodeA.name == "king" && contact.nodeB.name == "Bullet") ||
            (contact.nodeB.name == "king" && contact.nodeA.name == "Bullet"){
            
            
            let smoke = createSmoke( geometry: kingCrokNode.geometry!)
            kingCrokNode.addParticleSystem(smoke)
            kingcount += 1
            hit(node: kingCrokNode)
            bulletNode.isHidden = true
            if kingcount == 15 {
                
                
                game.playSound(node: kingCrokNode, name: "crokDead")
                
                kingcount = 0
                addTime(node: kingCrokNode)
                addTimeGraphic()
                updateScore(node: kingCrokNode)
                kingCrokNode.isHidden = true
                kingCrokNode.position.z = -30
                
                kingCrokNode.isHidden = false
                
                
                
            }
            
            
            
            
        }
        
        if (contact.nodeA.name == "crok" && contact.nodeB.name == "Bullet") ||
            (contact.nodeB.name == "crok" && contact.nodeA.name == "Bullet"){
            
            
            let smoke = createSmoke( geometry: crokNode.geometry!)
            crokNode.addParticleSystem(smoke)
            crokcount += 1
            hit(node : crokNode)
            bulletNode.isHidden = true
            if crokcount == 10 {
                
                game.playSound(node: crokNode, name: "crokDead")
                
                crokcount = 0
                addTime(node: crokNode)
                addTimeGraphic()
                updateScore(node: crokNode)
                crokNode.isHidden = true
                crokNode.position.z = -30
                crokNode.isHidden = false
                
            }
            
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
    }
    
}






