//
//  Singleton.swift
//  ColorGame
//
//  Created by Michael Craun on 9/4/17.
//  Copyright © 2017 Craunic Productions. All rights reserved.
//

import Foundation

class GameHandler {
    
    var score: Int
    var highScore: Int
    
    class var sharedInstance: GameHandler {
        
        struct Singleton {
            
            static let instance = GameHandler()
            
        }
        
        return Singleton.instance
        
    }
    
    init() {
        
        score = 0
        highScore = 0
        
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highScore")
        
    }
    
    func saveGameStats() {
        
        highScore = max(score, highScore)
        
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: "highScore")
        defaults.synchronize()
        
    }
    
}
