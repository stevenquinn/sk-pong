//
//  Paddle.swift
//  Pong iOS
//
//  Created by Steven Quinn on 4/17/24.
//

import SpriteKit

class Paddle: SKNode {
    
    let paddleShape: SKShapeNode
    let size = CGSize(width: 10, height: 100)
    
    override init() {
        
        paddleShape = SKShapeNode(rectOf: size)
        paddleShape.fillColor = .white
        
        super.init()
        
        zPosition = 1
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = CollisionsType.paddle.rawValue
        physicsBody?.collisionBitMask = CollisionsType.ball.rawValue
        physicsBody?.contactTestBitMask = CollisionsType.ball.rawValue
        addChild(paddleShape)
    }
    
    func setXPosition(_ xPosition: CGFloat) {
        position = CGPoint(x: xPosition, y: 0)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
