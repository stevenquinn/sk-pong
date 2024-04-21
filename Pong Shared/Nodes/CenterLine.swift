//
//  CenterLine.swift
//  Pong iOS
//
//  Created by Steven Quinn on 4/17/24.
//

import SpriteKit


class CenterLine: SKNode {
    
    let lineShape: SKShapeNode!
    
    init(_ height: CGFloat) {
        lineShape = SKShapeNode(rectOf: CGSize(width: 5, height: height))
        lineShape.fillColor = .white
        
        super.init()
        
        position = CGPoint(x: 0, y: 0)
        zPosition = 1
        
        addChild(lineShape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
