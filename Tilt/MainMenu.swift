//
//  MainMenu.swift
//  SpriteKitIntro
//
//  Created by LDC on 12/8/15.
//  Copyright © 2015 LDC. All rights reserved.
//

import SpriteKit
import CoreMotion

var score = 0;
var highscore = 0;

func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
}
func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
    return UIInterfaceOrientation.portrait
}

class MainMenu: SKScene {
    
    var myLabel:SKLabelNode!
    let manager = CMMotionManager()
    
    override func didMove(to view: SKView) {
        
        
        
        
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main){
            (data, error) in
            
            self.physicsWorld.gravity = CGVector(dx: CGFloat((data?.acceleration.x)!) * 10, dy: CGFloat((data?.acceleration.y)!) * 10)
            
        }
        
        if(score > highScore()){
            
            saveHighScore(score)
            print("New Highscore = " + highScore().description)
        }
        
        if let label = self.childNode(withName: "theScore") as? SKLabelNode {
            label.text = "score: \(String(score))"
        }
        if let label = self.childNode(withName: "highScore") as? SKLabelNode {
            label.text = "highscore: \(String(highScore()))"
        }
 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        score = 0;
        wrong = 0;
        number = 5
        number = 5
        counter = 0
        let game:GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .aspectFill
        let transition:SKTransition = SKTransition.crossFade(withDuration: 1.0)
        self.view?.presentScene(game, transition: transition)
        self.removeAllChildren()
    }
    
    func saveHighScore(_ high:Int) {
        UserDefaults.standard.set(high, forKey: "highscore")
    }
    func highScore() -> Int {
        return UserDefaults.standard.integer(forKey: "highscore")
    }

}
