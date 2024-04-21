//
//  GameOverLabel.swift
//  Pong iOS
//
//  Created by Steven Quinn on 4/19/24.
//

import SpriteKit


class WinnerLabel: SKLabelNode {
    
    override init() {
        super.init()
        color = .white
        fontSize = 96
        fontName = "Menlo-Bold"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ winner: String) {
        text = "\(winner) wins!"
    }
}

class PlayAgainLabel: SKLabelNode {
    
    override init() {
        super.init()
        text = "Tap to play again"
        color = .white
        fontSize = 24
        fontName = "Menlo"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class GameOver: SKNode {
    
    let overlay = SKShapeNode(rectOf: CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2))
    let winnerLabel = WinnerLabel()
    let playAgainLabel = PlayAgainLabel()
    
    override init() {
        super.init()
        overlay.zPosition = 1
        overlay.fillColor = UIColor(.black.opacity(0.5))
        addChild(overlay)
        
        winnerLabel.zPosition = 2
        addChild(winnerLabel)
        
        playAgainLabel.zPosition = 2
        playAgainLabel.position = CGPoint(x: 0.0, y: -80.0)
        addChild(playAgainLabel)
        isHidden = true
        zPosition = 10
        position = CGPoint(x: 0.0, y: 0.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ winner: String) {
        isHidden = false
        winnerLabel.show(winner)
    }
    
    func hide() {
        isHidden = true
        winnerLabel.text = ""
    }
}
