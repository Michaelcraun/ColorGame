//
//  GameFunctions.swift
//  ColorGame
//
//  Created by Michael Craun on 9/4/17.
//  Copyright © 2017 Craunic Productions. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func moveVertically(up: Bool) {
        
        if up {
            
            let moveAction = SKAction.moveBy(x: 0, y: 3, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            
            player?.run(repeatAction)
            
        } else {
            
            let moveAction = SKAction.moveBy(x: 0, y: -3, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            
            player?.run(repeatAction)
            
        }
    }
    
    func moveToNextTrack() {
        
        player?.removeAllActions()
        
        movingToTrack = true
        
        guard let nextTrack = tracksArray?[currentTrack + 1].position else { return }
        
        if let player = self.player {
            
            let moveAction = SKAction.move(to: CGPoint(x: nextTrack.x, y: player.position.y), duration: 0.2)
            let up = directionArray[currentTrack + 1]
            
            player.run(moveAction, completion: {
                
                self.movingToTrack = false
                
                if self.currentTrack != 8 {
                    
                    self.player?.physicsBody?.velocity = up ? CGVector(dx: 0, dy: self.velocityArray[self.currentTrack]) : CGVector(dx: 0, dy: -self.velocityArray[self.currentTrack])
                    
                } else {
                    
                    self.player?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    
                }
                
            })
            currentTrack += 1
            self.run(moveSound)
            
        }
    }
    
    func movePlayerToStart() {
        
        if let player = self.player {
            
            player.removeFromParent()
            self.player = nil
            self.createPlayer()
            self.currentTrack = 0
            
        }
    }
    
    func nextLevel(playerPhysicsBody: SKPhysicsBody) {
        
        currentScore += 1
        
        let emitter = SKEmitterNode(fileNamed: "fireworks.sks")
        playerPhysicsBody.node?.addChild(emitter!)
        
        self.run(SKAction.playSoundFileNamed("levelUp.wav", waitForCompletion: true))
        self.run(SKAction.wait(forDuration: 0.5)) {
            
            emitter?.removeFromParent()
            self.movePlayerToStart()
            
        }
    }
    
    func launchGameTimer() {
        
        let timeAction = SKAction.repeatForever(SKAction.sequence([SKAction.run({
            
            self.remainingTime -= 1
            
        }), SKAction.wait(forDuration: 1)]))
        
        timeLabel?.run(timeAction)
        
    }
    
    func gameOver() {
        
        GameHandler.sharedInstance.saveGameStats()
        
        self.run(SKAction.playSoundFileNamed("levelCompleted.wav", waitForCompletion: true))
        
        let trans = SKTransition.fade(withDuration: 1)
        
        if let gameOverScene = SKScene(fileNamed: "GameOverScene") {
            
            gameOverScene.scaleMode = .aspectFit
            self.view?.presentScene(gameOverScene, transition: trans)
            
        }
    }
}
