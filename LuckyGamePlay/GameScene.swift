//
//  GameScene.swift
//  LuckyGamePlay
//
//  Created by Jacqueline on 23.05.17.
//  Copyright © 2017 Jackys Code Factory. All rights reserved.
//

import SpriteKit
import GameplayKit

let BlockSize:CGFloat=20.0

//#1 Konstante, die das Minimum der Geschwindigkeit der Objekte festlegt (600 Millisekunden)
let TickLengthLevelOne = TimeInterval(600)

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x:6, y:-6)
    
//#2 Variable tickLengthMillis is the curent length of GameScene, lastTick is the last experienced tick

    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    var textureCache = Dictionary<String,SKTexture>()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
        
        addChild(gameLayer)
        
        let gameBoardTexture = SKTexture(imageNamed:"gameboard")
        let gameBoard = SKSpriteNode(texture:gameBoardTexture, size: CGSizeMake(BlockSize * CGFloat(NumColumns),BlockSize * CGFloat(NumRows)))
        gameBoard.anchorPoint = CGPoint(x:0,y:1.0)
        gameBoard.position = LayerPosition
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameBoard)
        
        
    }
    
    
    override func update(_ currentTime: CFTimeInterval) {
        // Called before each frame is rendered
        
        
       //#3 guard checks the conditions which follow in Swift
        guard let lastTick = lastTick else{
            return
        }
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
        if timePassed > tickLengthMillis{
            self.lastTick = NSDate()
            tick?() //is there already a tick()? if yes, invoe it with no parameters
        }
        
    }
    
    //#4 provided accessor methods to let external classes start and stop the ticking process
    func startTicking(){
        lastTick = NSDate()
    }
    
    func stopTicking(){
        lastTick = nil
    }
    
    
}
