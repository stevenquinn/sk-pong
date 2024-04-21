//
//  ScoreLabel.swift
//  Pong iOS
//
//  Created by Steven Quinn on 4/18/24.
//

import SpriteKit

class ScoreLabel: SKLabelNode {
    
    var score = 0
        
    init(_ isLeft: Bool = false) {
        let xOffset = 100.0
        let yOffset = Double(UIScreen.main.bounds.height / 2 * -1 - 60)
        
        super.init()
        
        color = .white
        fontSize = 48
        fontName = "Menlo-Bold"
        displayScore()
        
        position = CGPoint(x: isLeft ? -1 * xOffset : xOffset, y: yOffset)
    }
    
    func displayScore() {
        text = String(score)
    }
    
    func increment() {
        score += 1
        displayScore()
    }
    
    func reset() {
        score = 0
        displayScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(_ newScore: Int) {
        text = String(newScore)
    }
}
