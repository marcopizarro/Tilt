//
//  GameScene.swift
//  Color Tilt
//
//  Created by Marco Pizarro on 7/11/16.
//  Copyright (c) 2016 Mar.Co. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

// Universal Variables
let red :UInt32 = 0x1 << 0 // 1
let blue :UInt32 = 0x1 << 1 // 2
let green :UInt32 = 0x1 << 2 // 4
let yellow :UInt32 = 0x1 << 3 // 8
    
     let redEnd :UInt32 = 0x1 << 4 // 16
   let blueEnd :UInt32 = 0x1 << 5 // 32
    let greenEnd :UInt32 = 0x1 << 6// 64
    let yellowEnd :UInt = 0x1 << 7// 128

//intit timer
var timer2 = Timer()
//amount wrong
var wrong = 0;
//for intervals
var number = 5
var counter = 0
// to save when paused
var numberSave = 0
var counterSave = 0
// for music playing
var playing = false

var audioPlayer: AVAudioPlayer?
var audioPlayer1: AVAudioPlayer?
var audioPlayer2: AVAudioPlayer?



func playBackgroundMusic() {
    let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "mp3")!)
    do {
        audioPlayer = try AVAudioPlayer(contentsOf:aSound as URL)
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    } catch {
        print("Cannot play the file")
    }
}

func playWrongSound() {
    let theSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "wrong", ofType: "mp3")!)
    do {
        audioPlayer1 = try AVAudioPlayer(contentsOf:theSound as URL)
        audioPlayer1!.numberOfLoops = 0
        audioPlayer1!.prepareToPlay()
        audioPlayer1!.play()
    } catch {
        print("Cannot play the file")
    }
}

func playCorrectSound() {
    let anotherSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "mp3")!)
    do {
        audioPlayer2 = try AVAudioPlayer(contentsOf:anotherSound as URL)
        audioPlayer2!.numberOfLoops = 0
        audioPlayer2!.prepareToPlay()
        audioPlayer2!.play()
    } catch {
        print("Cannot play the file")
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let manager = CMMotionManager()
    var playerRed = SKSpriteNode()
    var redEnd = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        updateTimer()

        timer2.invalidate()
        
        number = 5
        
        self.physicsWorld.contactDelegate = self
        

        if playing == false
        {
            playBackgroundMusic()
            playing = true;
        }
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.05


        
        // for changing countdown label
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameScene.updateLabel)), userInfo: nil, repeats: true)
        
        
    }
    
    func updateLabel(){
        
        number -= 1
        counter += 1
    
        if let label = self.childNode(withName: "timerLabel") as? SKLabelNode {
            label.text = String(number)
        }
        print(number)
        
        if counter == 5{
        
            number = 5
            counter = 0
            if let label = self.childNode(withName: "timerLabel") as? SKLabelNode {
                label.text = String(number)
            }
        }
        if(counter % 5 == 0){
            updateTimer();
        }
        
        
    }
    
    func updateTimer(){

        print("updatingTimer")
        //random
        
        let random = Int(arc4random_uniform(4))

        // red
        if random == 0
        {
            print("Red")
            let ball:SKSpriteNode = SKScene(fileNamed: "ball")!.childNode(withName: "ball")! as! SKSpriteNode
            ball.removeFromParent()
            self.addChild(ball)
            ball.position = CGPoint(x: 165, y: 1755)
            ball.physicsBody?.categoryBitMask = red
            ball.color = UIColor(red: 1.0, green: 0.15, blue: 0.0, alpha: 1.0)
            
        }
        //blue
        if random == 1
        {
            print("Blue")
            let ball:SKSpriteNode = SKScene(fileNamed: "ball")!.childNode(withName: "ball")! as! SKSpriteNode
            ball.removeFromParent()
            self.addChild(ball)
            ball.position = CGPoint(x: 926.647, y: 150.475)
            ball.physicsBody?.categoryBitMask = blue
            ball.color = UIColor(red: 0.0, green: 0.53, blue: 0.96, alpha: 1.0)
        }
        //yellow
        if random == 2
        {
            print("Yellow")
            let ball:SKSpriteNode = SKScene(fileNamed: "ball")!.childNode(withName: "ball")! as! SKSpriteNode
            ball.removeFromParent()
            self.addChild(ball)
            ball.position = CGPoint(x: 944.973, y: 1755)
            ball.physicsBody?.categoryBitMask = yellow
            ball.color = UIColor(red: 0.94, green: 0.95, blue: 0.0, alpha: 1.0)
            
        }
        //green
        if random == 3
        {
            print("Green")
            let ball:SKSpriteNode = SKScene(fileNamed: "ball")!.childNode(withName: "ball")! as! SKSpriteNode
            ball.removeFromParent()
            self.addChild(ball)
            ball.position = CGPoint(x: 137.592, y: 146.377)
            ball.physicsBody?.categoryBitMask = green
            ball.color = UIColor(red: 0.51, green: 0.91, blue: 0.03, alpha: 1.0)
        }
        //end random section
    }
 
    


    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA = contact.bodyA;
        let bodyB = contact.bodyB;
        
        //red win
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 16 || bodyA.categoryBitMask == 16 && bodyB.categoryBitMask == 1{
            // test001
            if contact.bodyA.node?.name == "ball"
            {
                print("is A");
                bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.node?.name == "ball"{
                print("is B");
                bodyB.node?.removeFromParent()
            }
            //end test001
            score += 1
            print("you won!")
            playCorrectSound()
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = String(score)
            }
        }
        //red lose
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 32 || bodyA.categoryBitMask == 32 && bodyB.categoryBitMask == 1) || (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 64 || bodyA.categoryBitMask == 64 && bodyB.categoryBitMask == 1)||(bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 128 || bodyA.categoryBitMask == 128 && bodyB.categoryBitMask == 1){
            
            // test001
            if contact.bodyA.node?.name == "ball"
            {
                print("is A");
                bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.node?.name == "ball"{
                print("is B");
                bodyB.node?.removeFromParent()
            }
            //end test001
            
            wrong += 1
            //score -= 1
            print("you Lose!")
            playWrongSound()
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = String(score)
            }
            if let label = self.childNode(withName: "amountWrong") as? SKLabelNode {
                label.text = "\(String(wrong))/3"
            }
            if wrong >= 3{
                gameOver()
            }
            
        }
        //blue win
    
        if bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 32 || bodyA.categoryBitMask == 32 && bodyB.categoryBitMask == 2{
            // test001
            if contact.bodyA.node?.name == "ball"
            {
                print("is A");
                bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.node?.name == "ball"{
                print("is B");
                bodyB.node?.removeFromParent()
            }
            //end test001
            score += 1
            print("you won!")
            playCorrectSound()
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = String(score)
            }
        }
        //blue lose
        if (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 16 || bodyA.categoryBitMask == 16 && bodyB.categoryBitMask == 2) || (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 64 || bodyA.categoryBitMask == 64 && bodyB.categoryBitMask == 2)||(bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 128 || bodyA.categoryBitMask == 128 && bodyB.categoryBitMask == 2){
            // test001
            if contact.bodyA.node?.name == "ball"
            {
                print("is A");
                bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.node?.name == "ball"{
                print("is B");
                bodyB.node?.removeFromParent()
            }
            //end test001
            
            wrong += 1
            //score -= 1
            print("you Lose!")
            playWrongSound()
            
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = String(score)
            }
            if let label = self.childNode(withName: "amountWrong") as? SKLabelNode {
                label.text = "\(String(wrong))/3"
            }
            
            if wrong >= 3{
                gameOver()
            }
        }
                //green win
        
        if bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 64 || bodyA.categoryBitMask == 64 && bodyB.categoryBitMask == 4{
            // test001
            if contact.bodyA.node?.name == "ball"
            {
                print("is A");
                bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.node?.name == "ball"{
                print("is B");
                bodyB.node?.removeFromParent()
            }
            //end test001
            score += 1
            print("you won!")
            playCorrectSound()
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = String(score)
            }
        }
        //green lose
        if (bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 16 || bodyA.categoryBitMask == 16 && bodyB.categoryBitMask == 4) || (bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 128 || bodyA.categoryBitMask == 128 && bodyB.categoryBitMask == 4)||(bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 32 || bodyA.categoryBitMask == 32 && bodyB.categoryBitMask == 4){
            // test001
            if contact.bodyA.node?.name == "ball"
            {
                print("is A");
                bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.node?.name == "ball"{
                print("is B");
                bodyB.node?.removeFromParent()
            }
            //end test001
            wrong += 1
            //score -= 1
            print("you Lose!")
            playWrongSound()
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = String(score)
            }
            if let label = self.childNode(withName: "amountWrong") as? SKLabelNode {
                label.text = "\(String(wrong))/3"
            }
            
            if wrong >= 3{
                gameOver()
            }
        }
        //yellow win
        
        if bodyA.categoryBitMask == 8 && bodyB.categoryBitMask == 128 || bodyA.categoryBitMask == 128 && bodyB.categoryBitMask == 8{
            // test001
            if contact.bodyA.node?.name == "ball"
            {
                print("is A");
                bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.node?.name == "ball"{
                print("is B");
                bodyB.node?.removeFromParent()
            }
            //end test001
            score += 1
            print("you won!")
            playCorrectSound()
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = String(score)
            }
        }
        //yellow lose
        if (bodyA.categoryBitMask == 8 && bodyB.categoryBitMask == 16 || bodyA.categoryBitMask == 16 && bodyB.categoryBitMask == 8) || (bodyA.categoryBitMask == 8 && bodyB.categoryBitMask == 64 || bodyA.categoryBitMask == 64 && bodyB.categoryBitMask == 8)||(bodyA.categoryBitMask == 8 && bodyB.categoryBitMask == 32 || bodyA.categoryBitMask == 32 && bodyB.categoryBitMask == 8){
            // test001
            if contact.bodyA.node?.name == "ball"
            {
                print("is A");
                bodyA.node?.removeFromParent()
            }
            else if contact.bodyB.node?.name == "ball"{
                print("is B");
                bodyB.node?.removeFromParent()
            }
            //end test001
            wrong += 1
            //score -= 1
            print("you Lose!")
            playWrongSound()
            if let label = self.childNode(withName: "scoreLabel") as? SKLabelNode {
                label.text = String(score)
            }
            if let label = self.childNode(withName: "amountWrong") as? SKLabelNode {
                label.text = "\(String(wrong))/3"
            }
            
            if wrong >= 3{
                gameOver()
            }
        }
        
    }
    
    //if touch screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.scene?.isPaused == true){
        print("unpause")
        number = numberSave
        counter = counterSave
            
            // for changing countdown label
            timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameScene.updateLabel)), userInfo: nil, repeats: true)
            if let resume = self.childNode(withName: "resumeLabel") as? SKLabelNode {
                resume.isHidden = true;
            }
        self.scene?.isPaused = false
        return;
        }
        if(self.scene?.isPaused == false){
            self.scene?.isPaused = true
            print("pause")
            numberSave = number;
            counterSave = counter;
            timer2.invalidate()
            if let resume = self.childNode(withName: "resumeLabel") as? SKLabelNode {
                resume.isHidden = false;
            }
            if(self.scene?.isPaused == true){
                return;
            }
        }
    }
    

    
    func gameOver(){
        timer2.invalidate()
        number = 5
        counter = 0
        manager.stopAccelerometerUpdates()
        let game:GameScene = GameScene(fileNamed: "MainMenu")!
        game.scaleMode = .aspectFill
        let transition:SKTransition = SKTransition.crossFade(withDuration: 1.0)
        self.view?.presentScene(game, transition: transition)
        self.removeAllChildren()
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!) * 10, dy: CGFloat((data?.acceleration.y)!) * 10)
            
        }
    }
}
