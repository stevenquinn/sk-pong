//
//  Ball.swift
//  Pong iOS
//
//  Created by Steven Quinn on 4/17/24.
//

import SpriteKit

class Ball: SKNode {
    
    let shape: SKShapeNode
    let size = CGSize(width: 30, height: 30)
    let screenCollisionOffset = 5.0
    var xDirection = -1.0
    var yDirection = 0.0
    var velocity = CGFloat(400)
    let maxVelocity = CGFloat(4000)
    
    
    override init() {
        shape = SKShapeNode(rectOf: size)
        shape.fillColor = .white
        super.init()
        
        addChild(shape)
        
        zPosition = 2
        position = CGPoint(x: 0, y: 0)
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = CollisionsType.ball.rawValue
        physicsBody?.collisionBitMask = CollisionsType.paddle.rawValue
        physicsBody?.contactTestBitMask = CollisionsType.paddle.rawValue
    }
    
    func move() {
        
        // Use SKAction to move in the same direction forever until a collsion is detected.
        let moveAction = SKAction.moveBy(x: xDirection * velocity, y: yDirection, duration: 2.0)
        let sequence = SKAction.sequence([moveAction])
        run(SKAction.repeatForever(sequence))
    }
    
    // Get ready for another serve.
    func reset() {
        
        stop()
        position = CGPoint(x: 0, y: 0)
        velocity = CGFloat(400)
        yDirection = 0.0
    }
    
    func scoredLeft(_ sceneSize: CGSize) -> Bool {
        
        let nodeSize = size.width / 2
        let xMin = (sceneSize.width / 2 * -1) + nodeSize + screenCollisionOffset
        
        return position.x <= xMin && xDirection == -1
    }
    
    func scoredRight(_ sceneSize: CGSize) -> Bool {
        
        let nodeSize = size.width / 2
        let xMax = (sceneSize.width / 2) - nodeSize - screenCollisionOffset
        
        return position.x >= xMax && xDirection == 1
    }
    
    func didHitScreenEdges(_ sceneSize: CGSize) -> Bool {
        
        let min = sceneSize.height / 2
        let max = min * -1
        
        return position.y != 0.0  && (position.y <= min && yDirection <= 0) || (position.y >= max && yDirection >= 0)
    }
    
    func reflectOffScreen() {
        stop()
        yDirection *= -1
        velocity *= 1.2
        move()
    }
    
    func reverse(_ contactPercent: CGFloat) {
        stop()
        xDirection *= -1
        
        // Figure out the angle it needs to go based off of
        // how far off of center it hit.
        
        // Add that to the
        yDirection = yDirection + (100 * contactPercent)
        
        // Increase the velocity.
        velocity = min(velocity * 1.3, maxVelocity)
        
        move()
    }
    
    func stop() {
        removeAllActions()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
