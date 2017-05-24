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

 class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate  {
    
    var scene: GameScene!
    var swiftris:Swiftris!
    //tracking the last point on the screen at whicht a shape movement occurred or where a pan begins
    var panPointRefernece:CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Configure the view
        let skView = view as! SKView
        
        skView.isMultipleTouchEnabled = false
        
        //Create and configure the scene
        
        scene = GameScene (size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick
        
        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()
        
        //Present the scene
        
        skView.presentScene(scene)
    
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //function allows each gesture recognizer to work in tandem with the others
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // #6 function for case if swiping down a pan gesture may occur simultaneously with a swipe gesture
    //is conditionals check whether the generic UIGestureRecognizer parameters is of hte specific types of recognizers we expect to see
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        //recovering a point which defines the translation of the gesture relative to where it began (a measure of the distance that the user's finger has traveled)
        let currentPoint = sender.translation(in: self.view)
        if let originalPoint = panPointRefernece {
            // #3 jedes mal wenn der Nutzer 90% der Blockgröße über den Screen fährt, wird der Block in die entsprechende Richtung des Spielfelds verschoben
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                // #4 checking the velocity of the gesture, velocity gives us direction (from right to left/in which direction the shape has to be moved)
                if sender.velocity(in: self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointRefernece = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointRefernece = currentPoint
                }
            }
        } else if sender.state == .began {
            panPointRefernece = currentPoint
        }
    }
    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        swiftris.dropShape()
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }
    
    
    func didTick() {
        swiftris.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
            // #16 boolean which allows to shut down interaction with the view (users can't manipulate swiftris any way)
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(swiftris: Swiftris) {
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
        
    }
    
    //redraw the shape at its new location and then let it drop
    func gameShapeDidDrop(swiftris: Swiftris) {
        scene.stopTicking()
        scene.redrawShape(shape: swiftris.fallingShape!){
            swiftris.letShapeFall()
        }
    }
    
    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        nextShape()
    }
    
    // #17 after a shape has being moved, its representative sprites must be redrawn at their new locations
    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(shape: swiftris.fallingShape!) {}
    }

}
