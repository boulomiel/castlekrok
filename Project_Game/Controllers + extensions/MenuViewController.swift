//
//  MenuViewController.swift
//  Project_Game
//
//  Created by ruben mimoun on 16/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SpriteKit
import GameplayKit



class MenuViewController: UIViewController {
    
    var skView : SKView!
    var scene : SKScene!
    
    
    var emitter : SKEmitterNode!
    var randomX : CGFloat!
    var randomY : CGFloat!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    
    // Set the scene coordinates (0, 0) to the center of the screen.
    //scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    var userId = FirebaseManager.manager.userId
    private lazy var databaseReference : DatabaseReference = {
        return  Database.database().reference().child("Game")
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        
        setupFire()
        
        setupPlayLabel()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //  self.navigationController?.title = "Menu"
        
        
        
    }
    
    
    func setupScene(){
        
        skView = SKView(frame: view.frame)
        skView.allowsTransparency = true
        scene = SKScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        view.addSubview(skView)
        skView.presentScene(scene)
        
        
        
    }
    
    func setupFire() {
        
        emitter = SKEmitterNode(fileNamed: "fireParticule")
        emitter.position.y = scene.frame.minX - 10
        emitter.position.x = 0
        emitter.zPosition = 20
        
        scene.addChild(emitter)
        randomX = CGFloat.random(in: scene.frame.minX ... scene.frame.maxX )
        randomY = CGFloat.random(in: scene.frame.minY ... scene.frame.maxY )
        
        
        let launchFire = SKAction.move(to: CGPoint(x: randomX, y: randomY), duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        let removeNode  =  SKAction.removeFromParent()
        let again = SKAction.run {
            self.setupFire()
        }
        let sequenceAction = SKAction.sequence([launchFire,fadeOut,removeNode,again])
        
        emitter.run(sequenceAction)
        
    }
    
    func setupPlayLabel(){
        
        let labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
        labelNode.color = .white
        labelNode.alpha = 1
        labelNode.fontSize = 40
        labelNode.position.y = skView.frame.height / 2
        labelNode.position.x = skView.frame.width / 2
        labelNode.text = "Play"
        
        
        scene.addChild(labelNode)
        
        let fadeOut =  SKAction.fadeOut(withDuration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let textActionClick = SKAction.run {
            labelNode.text = "Click To"
        }
        let textActionPlay = SKAction.run {
            labelNode.text = "Play"
        }
        let sequencePlay = SKAction.sequence([fadeOut,textActionClick,fadeIn,fadeOut,textActionPlay,fadeIn])
        let foreverSquencePlay = SKAction.repeatForever(sequencePlay)
        
        labelNode.run(foreverSquencePlay)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //performSegue(withIdentifier: "game", sender: nil)
        let vc = UIStoryboard(name: "Game", bundle: nil).instantiateInitialViewController()
        
        self.view.window?.rootViewController?.present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func logOutAction(_ sender: Any) {
        logOut()
    }
    
    
    func logOut(){
        
        guard let uid = self.userId else {
            return
        }
        
        try! Auth.auth().signOut()
        
        skView.removeFromSuperview()
        
        databaseReference.child(uid).removeAllObservers()
        FlowController.shared.determineRoot()
        
        
    }
    
    
    
    
}
