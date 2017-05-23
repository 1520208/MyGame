//
//  GameViewController.swift
//  LuckyGamePlay
//
//  Created by Jacqueline on 23.05.17.
//  Copyright © 2017 Jackys Code Factory. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        
        skView.isMultipleTouchEnabled = false
        
        //Create and configure the scene
        
        scene = GameScene (size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        //Present the scene
        
        skView.presentScene(scene)
        
        
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }
}
