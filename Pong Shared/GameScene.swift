//
//  GameScene.swift
//  Pong Shared
//
//  Created by Steven Quinn on 4/17/24.
//

import SpriteKit

class GameScene: SKScene {
    
    // Game mechanics
    var viewSize = CGSize()
    let maxScore = 15

    // Assets
    let player1Paddle = Paddle()
    let player2Paddle = Paddle()
    let player1Score = ScoreLabel(true)
    let player2Score = ScoreLabel()
    let gameOver = GameOver()
    let paddleOffset = 100.0
    let ball = Ball()
    
    // Interaction
    var previousLeftTouchY: CGFloat?
    var previousRightTouchY: CGFloat?
    
    // Sound
    let pingSound = SKAction.playSoundFileNamed("ping.mp3", waitForCompletion: false)
    let pongSound = SKAction.playSoundFileNamed("pong.mp3", waitForCompletion: false)
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        
        physicsWorld.contactDelegate = self

        // We need this to figure out how to scale / position everything.
        viewSize = viewSizeInLocalCoordinates()
        
        // The line dividing the two sides
        addChild(CenterLine(viewSize.height))
        
        // Player 1 paddle.
        player1Paddle.setXPosition(-1 * (viewSize.width / 2) + paddleOffset)
        addChild(player1Paddle)
        
        // Player 2 paddle.
        player2Paddle.setXPosition(viewSize.width / 2 - paddleOffset)
        addChild(player2Paddle)
        
        // The ball that bounces around.
        addChild(ball)
        
        // Text elements.
        addChild(player1Score)
        addChild(player2Score)
        addChild(gameOver)
    }
    
    
    // Moves the paddle based on incoming touch events data.
    func calculatePaddlePosition(_ paddle: SKNode, deltaY: CGFloat) {
        
        // Adjust paddle's position based on deltaY
        let paddleSpeed: CGFloat = 0.5 // Adjust as needed
        let newY = paddle.position.y + deltaY * paddleSpeed
        paddle.position.y = newY
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
        ball.move()
    }   
    
    
    // Has a player hit the max score?
    func gameIsDone() -> Bool {
        
        return player1Score.score >= maxScore || player2Score.score >= maxScore
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Did the ball go off the left side of the screen?
        if ball.scoredLeft(viewSize) {
            scored(player2Score)
        }
        
        // Did it go off the right side?
        if ball.scoredRight(viewSize) {
            scored(player1Score)
        }
        
        if gameIsDone() {
            showGameOver()
        }
        
        // Did it bounce off the top or bottom?
        if ball.didHitScreenEdges(viewSize) {
            run(pongSound)
            ball.reflectOffScreen()
        }
    }

    
    // One of the players scored. Reset and get read to serve again.
    func scored(_ label: ScoreLabel) {
        
        ball.reset()
        ball.move()
        label.increment()
    }
    
    // Game is over, show the UI for it and stop play.
    func showGameOver() {
        gameOver.show(player1Score.score >= maxScore ? "Player 1" : "Player 2")
        ball.stop()
    }
    
    // Reset the game to starting conditions.
    func restart() {
        ball.reset()
        player1Score.reset()
        player2Score.reset()
        gameOver.hide()
        ball.move()
    }
}


/**
 * Stolen from https://stackoverflow.com/questions/35430355/spritekit-getting-the-actual-size-frame-of-the-visible-area-on-scaled-scenes
 * This is used to calculate the local game scene size this due to the .aspectFill it will scale depending on the device
 * */

extension SKScene {
    func viewSizeInLocalCoordinates() -> CGSize {
        let reference = CGPoint(x: view!.bounds.maxX, y: view!.bounds.maxY)
        let bottomLeft = convertPoint(fromView: .zero)
        let topRight = convertPoint(fromView: reference)
        let d = topRight - bottomLeft
        return CGSize(width: d.x, height: d.y)
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

// End Stealing.


extension GameScene: SKPhysicsContactDelegate {
    
    // Detect a collision event with a paddle and send the ball going the other way.
    // Angle of deflection will be based on angle of hit.
    func didBegin(_ contact: SKPhysicsContact) {
        let contactPoint = contact.contactPoint
        let nodeA = contact.bodyA.node
        
        // Convert the contact point to the coordinate system of one of the nodes
        // We'll convert it to the coordinate system of nodeA
        if let convertedContactPoint = nodeA?.convert(contactPoint, from: self) {
            
            // Convert this to a percentage
            let hitPercentage = (convertedContactPoint.y - (ball.size.height / 2)) / (player1Paddle.size.height / 2);
            
            run(pingSound)
            ball.reverse(hitPercentage)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Handle restarting the game if it's game over.
        if gameIsDone() {
            for touch in touches {
                let location = touch.location(in: self)
                
                if gameOver.contains(location) {
                    restart()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Is there a touch on the left side of the screen?
        if let leftTouch = touches.filter({ $0.location(in: self).x < 0 }).first {
            let currentY = leftTouch.location(in: self).y
            if let previousY = previousLeftTouchY {
                let deltaY = currentY - previousY
                calculatePaddlePosition(player1Paddle, deltaY: deltaY)
            }
            previousLeftTouchY = currentY
        } else {
            previousLeftTouchY = nil
        }
        
        // Right side is player 2
        if let rightTouch = touches.filter({ $0.location(in: self).x > 0 }).first {
            let currentY = rightTouch.location(in: self).y
            if let previousY = previousRightTouchY {
                let deltaY = currentY - previousY
                calculatePaddlePosition(player2Paddle, deltaY: deltaY)
            }
            previousRightTouchY = currentY
        } else {
            previousRightTouchY = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Reset previous touch positions when touches end
        previousLeftTouchY = nil
        previousRightTouchY = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
    }
    
    override func mouseDragged(with event: NSEvent) {
    }
    
    override func mouseUp(with event: NSEvent) {
    }

}
#endif

