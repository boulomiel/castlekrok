//
//  ViewController.swift
//  Project_Game
//
//  Created by ruben mimoun on 08/03/2020.
//  Copyright © 2020 ruben mimoun. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import MetalKit
import VideoToolbox
import AVFoundation

struct CollisionCategory {
    
    static let Hero: Int = 1
    static let Monster: Int = 2
    static let Bullet: Int = 4
    static let Castle : Int = 8
}

class GameController: UIViewController, UIGestureRecognizerDelegate {
    
    var game : GameHelper {
        return GameHelper.sharedInstance
    }
    
    
    var musicPlayer : SCNAudioPlayer!
    
    var sceneView : SCNView!
    var splashScene : SCNScene!
    var gameScene : SCNScene!
    
    var cameraNode : SCNNode!
    var followCamera : SCNNode!
    var followLight : SCNNode!
    var enemyNode : SCNNode!
    var pigNode : SCNNode!
    var crokNode : SCNNode!
    var kingCrokNode : SCNNode!
    var castle : SCNNode!
    var scoreBoard : SCNNode!
    var plus1Node : SCNNode!
    var plus2Node : SCNNode!
    var plus3Node : SCNNode!
    var HPnode: SCNNode!
    var lifes : [SCNNode]!
    var treeNode : SCNNode!
    
    var score : Int = 0
    var kingcount = 0
    var crokcount = 0
    
    var labelNode:SKLabelNode!
    var timeLabel : SKLabelNode!
    
    //MARK: config
    let autofireTapTimeThreshold = 0.2
    let maxRoundsPerSecond = 30
    let bulletRadius = 0.05
    let bulletImpulse = 15
    let maxBullets = 100
    
    var lookGesture: UIPanGestureRecognizer!
    var walkGesture: UIPanGestureRecognizer!
    var fireGesture: FireGestureRecognizer!
    var heroNode: SCNNode!
    var camNode: SCNNode!
    var elevation: Float = 0
    
    var crokHeight = CGFloat()
    
    var vibrateUp : SCNAction!
    var vibrateDown : SCNAction!
    var vibrationDownCAmera : SCNAction!
    var vibrateRight : SCNAction!
    var vibrateLeft : SCNAction!
    var vibration : SCNAction!
    var vibrationCamera : SCNAction!
    var actionScoreBoard : SCNAction!
    
    
    var tapCount = 0
    var lastTappedFire: TimeInterval = 0
    var lastFired: TimeInterval = 0
    var bulletNode: SCNNode!
    var bullets = [SCNNode]()
    var countDown = CountDown()
    
    var randProgress : CGFloat!
    var randTimer : Float!
    
    var speedCoef : Float! = 1
    
    var heroTouched = false
    var plus3Bool  = false
    var plus2Bool = false
    var plus1Bool = false
    var addersPos : SCNVector3!
    var fadeInTimer : SCNAction!
    var actionUpTime : SCNAction!
    var actionDownTime : SCNAction!
    var fadeOutTime : SCNAction!
    var actionTime : SCNAction!
    var rotateScoreBoardLeft : SCNAction!
    var rotateScoreBoardRight : SCNAction!
    var rotateScoreBoardBack  : SCNAction!
    var rotateScoreBoardZ : SCNAction!
    var rotateHeart : SCNAction!
    var actionHeart : SCNAction!
    var fadeOutHeart : SCNAction!
    
    var gameOver : SCNAction!
    var tiggerGameOver : SCNAction!
    
    var max : Int!
    var noLife : Bool!
    
    var kingPos : SCNVector3!
    
    var textfield : UITextField!
    var enemyDead : Bool = false 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isHEVCHardwareEncodingSupported()){
            print("supported")
        }
        
        let back = UIBarButtonItem(title: "Back to Menu", style: .done, target: self, action: #selector(backtomenu(_:)))
        self.navigationItem.leftBarButtonItem  = back
        // Do any additional setup after loading the view.
        
        setupScene()
        
        setupNodes()
        
        setupGestures()
        
        setupSounds()
        
        setupScoreBoard()
        
        
    }
    
    func isHEVCHardwareEncodingSupported() -> Bool {
        let encoderSpecDict : [String : Any] =
            [kVTCompressionPropertyKey_ProfileLevel as String : kVTProfileLevel_HEVC_Main_AutoLevel,
             kVTCompressionPropertyKey_RealTime as String : true]
        
        let status = VTCopySupportedPropertyDictionaryForEncoder(width: 3840, height: 2160,
                                                                 codecType: kCMVideoCodecType_HEVC,
                                                                 encoderSpecification: encoderSpecDict as CFDictionary,
                                                                 encoderIDOut: nil, supportedPropertiesOut: nil)
        if status == kVTCouldNotFindVideoEncoderErr {
            return false
        }
        
        if status != noErr {
            return false
        }
        
        return true
    }
    
    
    @objc func backtomenu(_ sender : Any){
        removeActions()
        let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateInitialViewController()
        self.view.window?.rootViewController = vc!
    }
    
    
    
    func setupScene(){
        
        sceneView = SCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        splashScene = SCNScene(named: "/MyAssets.scnassets/SplashScreen.scn")
        gameScene = SCNScene(named: "/MyAssets.scnassets/GameScene.scn")
        
        sceneView.scene = splashScene
        
        sceneView.antialiasingMode = .multisampling4X
        
        
        
        sceneView.delegate = self
        gameScene.physicsWorld.contactDelegate = self
        
        game.state = .tapToPlay
        
        
    }
    
    
    func setupNodes(){
        
        
        heroNode = gameScene.rootNode.childNode(withName: "Player", recursively: true)!
        heroNode.name = "hero"
        heroNode.physicsBody?.categoryBitMask = CollisionCategory.Hero
        
        
        heroNode.physicsBody?.contactTestBitMask = CollisionCategory.Monster
        pigNode = gameScene.rootNode.childNode(withName: "PigPig", recursively: true)!
        pigNode.name = "pig"
        kingCrokNode = gameScene.rootNode.childNode(withName: "KingCroko", recursively: true)!
        kingCrokNode.name = "king"
        crokNode = gameScene.rootNode.childNode(withName: "Crok", recursively: true)!
        crokNode.name = "crok"
        followCamera = gameScene.rootNode.childNode(withName: "FollowCamera", recursively: true)!
        cameraNode = gameScene.rootNode.childNode(withName: "camera", recursively: true)!
        castle = gameScene.rootNode.childNode(withName: "Castle", recursively: true)!
        castle.name = "castle"
        
        scoreBoard = gameScene.rootNode.childNode(withName: "Score", recursively: true)!
        
        followLight = gameScene.rootNode.childNode(withName: "Lights", recursively: true)!
        
        HPnode = gameScene.rootNode.childNode(withName: "HP", recursively: true)!
        lifes = HPnode.childNodes
        max = lifes.count - 1
        
        
        
        plus1Node = gameScene.rootNode.childNode(withName: "plus1", recursively: true)!
        plus2Node = gameScene.rootNode.childNode(withName: "plus2", recursively: true)!
        plus3Node = gameScene.rootNode.childNode(withName: "plus3", recursively: true)!
        plus1Node.opacity = 0
        plus2Node.opacity = 0
        plus3Node.opacity = 0
        
        
        treeNode = gameScene.rootNode.childNode(withName: "Trees", recursively: true)!
        
        
    }
    
    
    func playerHurt(){
        
        
        game.playSound(node: heroNode, name: "hurt")
        for _ in lifes {
            
            if !lifes[max].isHidden{
                
                lifes[max].runAction(fadeOutHeart)
                lifes[max].opacity = 0
                heroTouched = false
                
                
                
            }
            
        }
        
        max -= 1
        
    }
    
    func addTimeGraphic(){
        guard game.state == .playing else {return}
        
        
        guard enemyDead else {return}
        
        if plus3Bool{
            plus3Node.isHidden = false
            plus3Node.runAction(actionTime)
            scoreBoard.runAction(actionScoreBoard)
            plus3Bool = false
            enemyDead = false
            
        }
        
        if plus2Bool{
            plus2Node.isHidden = false
            plus2Node.runAction(actionTime)
            scoreBoard.runAction(actionScoreBoard)
            
            plus2Bool = false
            enemyDead = false
            
        }
        
        if plus1Bool{
            plus1Node.isHidden = false
            plus1Node.runAction(actionTime)
            scoreBoard.runAction(actionScoreBoard)
            plus1Bool = false
            enemyDead = false
            
        }
        
    }
    
    func addTime(node : SCNNode!){
        
        
        switch node.name {
            case "king" :
                countDown.addTime(duration: 3)
                plus3Bool = true
                break
            case "crok" :
                countDown.addTime(duration: 2)
                plus2Bool = true
                break
            case "pig" :
                countDown.addTime(duration: 1)
                plus1Bool = true
                break
            default :
                break
            
        }
        
        
    }
    
    func setupSounds(){
        
        if game.state == .tapToPlay {
            let music = SCNAudioSource(fileNamed: "MyAssets.scnassets/Audio/theme.mp3")
            music!.volume = 0.3;
            musicPlayer = SCNAudioPlayer(source: music!)
            music!.loops = true
            music!.shouldStream = true
            music!.isPositional = false
            splashScene.rootNode.addAudioPlayer(musicPlayer)
            
        } else if game.state == .playing {
            
            let theme = SCNAudioSource(fileNamed: "MyAssets.scnassets/Audio/ingame.mp3")
            theme!.volume = 0.1
            let themeplayer = SCNAudioPlayer(source: theme!)
            theme!.loops = true
            theme!.shouldStream = true
            theme!.isPositional = true
            gameScene.rootNode.addAudioPlayer(themeplayer)
            
            game.loadSound(name: "gun", fileNamed: "MyAssets.scnassets/Audio/gun.mp3")
            game.loadSound(name: "hurt", fileNamed: "MyAssets.scnassets/Audio/hurt.mp3")
            game.loadSound(name: "crokDead", fileNamed: "MyAssets.scnassets/Audio/crokdead.mp3")
            game.loadSound(name: "lose", fileNamed: "MyAssets.scnassets/Audio/loose.mp3")
            game.loadSound(name: "pigHit", fileNamed: "MyAssets.scnassets/Audio/pigHit.mp3")
            game.loadSound(name: "pigDead", fileNamed: "MyAssets.scnassets/Audio/pigDead.mp3")
            
        }
        
    }
    
    func setupScoreBoard(){
        
        let skScene = SKScene(size: CGSize(width: 500, height: 100))
        
        labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
        labelNode.color = .black
        labelNode.alpha = 1
        labelNode.fontSize = 40
        labelNode.position.y = 59
        labelNode.position.x = 250
        
        countDown.color = .black
        countDown.position.y = 20
        countDown.position.x = 250
        
        
        
        labelNode.text = "Score : \(score)"
        
        skScene.addChild(labelNode)
        skScene.addChild(countDown)
        
        let material = SCNMaterial()
        material.lightingModel = SCNMaterial.LightingModel.constant
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        scoreBoard.geometry?.materials = [material]
        
        scoreBoard.rotation = SCNVector4(x: 1, y: 0, z: 0, w: 3.14159265)
        
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if gestureRecognizer == lookGesture {
            
            return true
            
        } else if gestureRecognizer == walkGesture {
            
            return touch.location(in: view).x < view.frame.size.width / 2
        }
        return true
    }
    
    
    func setupGestures(){
        
        //look gesture
        lookGesture = UIPanGestureRecognizer(target: self, action: #selector(lookGestureRecognized(gesture:)))
        lookGesture.delegate = self
        view.addGestureRecognizer(lookGesture)
        
        //walk gesture
        walkGesture = UIPanGestureRecognizer(target: self, action: #selector(walkGestureRecognized(gesture:)))
        walkGesture.delegate = self
        view.addGestureRecognizer(walkGesture)
        
        
        //fire gesture
        fireGesture = FireGestureRecognizer(target: self, action: #selector(fireGestureRecognized(gesture:)))
        fireGesture.delegate = self
        view.addGestureRecognizer(fireGesture)
        
    }
    
    func updateScore(node : SCNNode!){
        
        switch node.name {
            case "king":
                score += 10
                break
            case "crok" :
                score += 5
                break
            case "pig" :
                score += 1
                break
            
            default:
                break
        }
        
    }
    
    
    
    
    
    func startGame(){
        splashScene.isPaused = true
        let transition = SKTransition.flipHorizontal(withDuration: 2)
        sceneView.present(gameScene, with: transition, incomingPointOfView: nil) {
            self.gameScene.isPaused = false
            self.crokHeight = self.randomHeight()
            self.setupActions()
            self.setupSounds()
            self.kingPos = self.kingCrokNode.position
            self.noLife = false
            self.resetLifes()
            self.score = 0
            
        }
        
    }
    
    func resetLifes(){
        
        for life in lifes{
            life.runAction(actionHeart)
            life.opacity = 1
        }
        max = lifes.count - 1
    }
    
    func restartGame(){
        
        FirebaseManager.manager.addNewScore(with: self.score)
        self.navigationController?.isNavigationBarHidden = false
        
        
        pigNode.position.z = -30
        gameScene.isPaused = true
        let transition = SKTransition.flipVertical(withDuration: 2)
        sceneView.present(splashScene, with: transition, incomingPointOfView: nil) {
            self.game.state = .tapToPlay
            self.setupSounds()
            self.splashScene.isPaused = false
            self.removeActions()
            
            
        }
    }
    
    func removeActions(){
        for life in lifes{life.removeAllActions()}
        cameraNode.removeAllActions()
        pigNode.removeAllActions()
        crokNode.removeAllActions()
        kingCrokNode.removeAllActions()
        
    }
    
    
    
    
    
    
    func setupActions(){
        guard game.state == .playing else {return}
        
        crokHeight = randomHeight()
        
        rotateHeart = SCNAction.rotateBy(x: 0, y: 10, z: 0, duration: 3)
        actionHeart = SCNAction.repeatForever(rotateHeart)
        fadeOutHeart = SCNAction.fadeOut(duration: 1.5)
        
        for life in lifes{
            life.runAction(actionHeart)
        }
        
        addersPos =  SCNVector3(2,7,-28)
        fadeInTimer = SCNAction.fadeIn(duration: 1)
        actionUpTime = SCNAction.moveBy(x: 0, y: 0.1, z: 0, duration: 1)
        actionDownTime = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 1)
        fadeOutTime = SCNAction.fadeOut(duration: 1)
        
        actionTime = SCNAction.sequence([fadeInTimer,actionUpTime,actionDownTime,fadeOutTime])
        
        
        
        rotateScoreBoardLeft = SCNAction.rotateBy(x: 0, y: -0.2, z: 0, duration: 0.5)
        rotateScoreBoardRight = SCNAction.rotateBy(x: 0 , y: 0.4, z: 0, duration: 0.5)
        rotateScoreBoardBack = SCNAction.rotateBy(x: 0, y: -0.2, z: 0, duration: 0.5)
        rotateScoreBoardZ = SCNAction.rotateBy(x: 0, y: 360, z: 0, duration: 0.8)
        
        actionScoreBoard = SCNAction.sequence([rotateScoreBoardLeft,rotateScoreBoardRight,rotateScoreBoardBack])
        
        
        
        let upAction = SCNAction.moveBy(x: 0, y: 2, z: 0, duration: 0.5)
        let upActionPig = SCNAction.moveBy(x: 0, y: 1.0, z: 0, duration: 0.5)
        let downActionPig = SCNAction.moveBy(x: 0, y: -1.0, z: 0, duration: 0.5)
        
        
        let leftKIng =  SCNAction.moveBy(x: -2, y: 0, z: 0, duration: 0.1)
        let rightKIng =  SCNAction.moveBy(x: 4, y: 0, z: 0, duration: 0.1)
        
        
        vibrateUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 0.05)
        vibrateDown = SCNAction.moveBy(x: 0, y: -0.3, z: 0, duration: 0.05)
        vibrationDownCAmera = SCNAction.move(to: SCNVector3(-0.15,0.15,0), duration: 0.05)
        vibrateLeft = SCNAction.moveBy(x: 0.2, y: 0, z: 0, duration: 0.05)
        vibrateRight = SCNAction.moveBy(x: -0.2, y: 0, z: 0, duration: 0.05)
        vibration = SCNAction.sequence([vibrateUp,vibrateDown,vibrateLeft,vibrateRight,vibrateUp,vibrateDown,vibrateLeft,vibrateRight])
        
        vibrationCamera = SCNAction.sequence([vibrateUp,vibrateDown,vibrateLeft,vibrateRight,vibrateUp,vibrationDownCAmera,vibrateLeft,vibrateRight])
        
        upAction.timingMode = .easeOut
        upActionPig.timingMode = .easeOut
        downActionPig.timingMode = .easeIn
        
        let forwarActionPig = SCNAction.moveBy(x:0 , y: 0, z: 10 * CGFloat(speedCoef), duration: 1.0)
        let sequencePig = SCNAction.sequence([forwarActionPig,upActionPig,downActionPig])
        let runPig  = SCNAction.repeatForever(sequencePig)
        pigNode.runAction(runPig)
        
        let forwardAction = SCNAction.moveBy(x:0 , y: 0, z: CGFloat(10 * speedCoef), duration: 1)
        let downActionKIng = SCNAction.moveBy(x: 0, y: -2, z: 0, duration: 1)
        let sequenceCrok =  SCNAction.sequence([forwardAction,downActionKIng,upAction])
        let forwardcrok  = SCNAction.repeatForever(sequenceCrok)
        crokNode.runAction(forwardcrok)
        
        let sequenceKing =  SCNAction.sequence([forwardAction,leftKIng,downActionKIng,rightKIng,upAction, leftKIng])
        let forwardcrokKing  = SCNAction.repeatForever(sequenceKing)
        kingCrokNode.runAction(forwardcrokKing)
        
        
        let pigMove = SCNAction.move(to: SCNVector3(0,-2,5), duration: 0.2)
        let pigDanceLeft = SCNAction.moveBy(x: 0.5, y: 0, z: 0, duration: 1)
        let pigDanceRight = SCNAction.moveBy(x: -0.5, y: 0, z: 0, duration: 1)
        let pigDanceUp = SCNAction.moveBy(x: 0, y: 0.5, z: 0.5, duration: 1)
        let pigDanceDown = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 1)
        let pigdance  = SCNAction.sequence([pigMove,pigDanceUp,pigDanceDown,pigDanceLeft,pigDanceRight])
        
        gameOver = SCNAction.waitForDurationThenRunBlock(duration: 2) { (node:SCNNode!) -> Void in
            self.game.playSound(node: self.heroNode, name: "lose")
            self.pigNode.position = SCNVector3(0, 0, 5)
            self.restartGame()
            
        }
        
        
        tiggerGameOver = SCNAction.sequence([pigdance,gameOver])
        
    }
    
    
    func hit(node : SCNNode!){
        node.runAction(vibration)
        node.position.y -= 0.5
    }
    
    func randomHeight() -> CGFloat {
        let random  = Float.random(in: 1...3)
        return CGFloat(random)
    }
    
    
    
    
    
    func getForwardAction(node : SCNNode!) -> SCNAction{
        
        randProgress = CGFloat.random(in: 5...12)
        randTimer = Float.random(in: 0...1)
        
        let move = SCNAction.moveBy(x: 0, y: CGFloat(node.position.y), z: randProgress * CGFloat(speedCoef), duration: TimeInterval(randTimer))
        move.timingMode = .easeIn
        
        return move
    }
    
    
    func speedUpgrade(){
        if score > 50{
            self.speedCoef *= 1.2
        }
        
        if score > 100{
            self.speedCoef *= 1.2
        }
        
        if score > 150{
            self.speedCoef *= 1.2
        }
        
        
    }
    
    func updatePositions(){
        
        if pigNode.position.z > 20 {
            pigNode.position.z = -30
            cameraNode.runAction(vibrationCamera)
            playerHurt()
            
            
        }
        if crokNode.position.z > 18{
            crokNode.position.z = -30
            crokNode.position.y = 2
            crokHeight = 0
            cameraNode.runAction(vibrationCamera)
            playerHurt()
            
        }
        
        if kingCrokNode.position.z > 28{
            kingCrokNode.position = SCNVector3(0,2,-30)
            crokHeight = 0
            cameraNode.runAction(vibrationCamera)
            playerHurt()
            
        }
        
        
        if kingCrokNode.position.y < 0 {
            kingCrokNode.position.y = 0
        }
        
        
        
        if crokNode.position.y < 0 {
            crokNode.position.y = 0
        }
    }
    
    
    func createSmoke( geometry: SCNGeometry) -> SCNParticleSystem {
        let trail = SCNParticleSystem(named: "SmokeShot", inDirectory: nil)!
        trail.emitterShape = geometry
        return trail
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if game.state == .tapToPlay{
            self.navigationController?.isNavigationBarHidden = true
            game.state = .playing
            countDown.startWithDuration(duration: TimeInterval(30))
            startGame()
            
        }
        
        
    }
    
    
    @objc func lookGestureRecognized(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self.view)
        let hAngle = acos(Float(translation.x) / 200) - Float(Double.pi / 2)
        let vAngle = acos(Float(translation.y) / 200) - Float(Double.pi / 2)
        
        //rotate hero
        heroNode.physicsBody?.applyTorque(SCNVector4(x: 0, y: 1, z: 0, w: hAngle), asImpulse: true)
        
        elevation = Swift.max(Float(-Double.pi / 4), min(Float(Double.pi / 4), elevation + vAngle))
        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: elevation)
        
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func walkGestureRecognized(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.ended || gesture.state == UIGestureRecognizer.State.cancelled {
            gesture.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc func fireGestureRecognized(gesture: FireGestureRecognizer) {
        
        //update timestamp
        let now = CFAbsoluteTimeGetCurrent()
        if now - lastTappedFire < autofireTapTimeThreshold {
            tapCount += 1
        } else {
            tapCount = 1
        }
        lastTappedFire = now
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ProgressView.hud.setProgressView(title: "Loading...")
        splashScene.rootNode.removeAllAudioPlayers()
        gameScene.rootNode.removeAllAudioPlayers()
        ProgressView.hud.closeProgressView()
        
    }
    
    
}


