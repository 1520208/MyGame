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
import AVFoundation

 class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate  {
    
    var scene: GameScene!
    var swiftris:Swiftris!
     var audioPlayer: AVAudioPlayer = AVAudioPlayer()

    //tracking the last point on the screen at whicht a shape movement occurred or where a pan begins
    var panPointRefernece:CGPoint?
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    

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
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    // #6 function for case if swiping down a pan gesture may occur simultaneously with a swipe gesture
    //is conditionals check whether the generic UIGestureRecognizer parameters is of hte specific types of recognizers we expect to see
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        if swiftris.level == 1 {
            playSound(sound: "/Users/jacquelinefranssen/Desktop/MyGame/Blocs/Sounds/first.mp3")
        }else {
            stop(sound: "/Users/jacquelinefranssen/Desktop/MyGame/Blocs/Sounds/first.mp3")
        }
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
        scene.playSound(sound: "Sounds/gameover.mp3")
        scene.animateCollapsingLines(linesToRemove: swiftris.removeAllBlocks(), fallenBlocks: swiftris.removeAllBlocks()) {
            swiftris.beginGame()
        }
        
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
        levelLabel.text = "\(swiftris.level)"
        if scene.tickLengthMillis >= 50 {
            scene.tickLengthMillis -= 20
        } else if scene.tickLengthMillis > 20 {
            scene.tickLengthMillis -= 30
        }
       
        scene.playSound(sound: "Sounds/levelup.mp3")
        if swiftris.level == 2 {
            playSound(sound: "/Users/jacquelinefranssen/Desktop/MyGame/Blocs/Sounds/first.mp3")
        }else {
            stop(sound: "Sounds/first.mp3")
        }
        if swiftris.level == 3 {
            playSound(sound: "Sounds/third.mp3")
        }else {
            stop(sound: "Sounds/third.mp3")
        }
        if swiftris.level == 4 {
            playSound(sound: "Sounds/fourth.mp3")
        }else {
            stop(sound: "Sounds/fourth.mp3")
        }
    }
    
    func playSound(sound:String) {
        audioPlayer.play()
        var path = Bundle.main.path(forResource: sound, ofType: "mp3", inDirectory: "Sounds")
        var player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path!))
        var player.prepareToPlay()
        audioPlayer.play()
        
        //run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
    }
    
    func stop(sound:String) {
        audioPlayer.stop()
        print(audioPlayer.currentTime)
        audioPlayer.currentTime = 0
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
        self.view.isUserInteractionEnabled = false
        // #10 are there any completed lines? if so, remove them
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(swiftris.score)"
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                // #11 after the blocks have fallen to their new location, they may have formed brand new lines. gameShapeDidLand invokes itself= recursion, it detects any new lines
                self.gameShapeDidLand(swiftris: swiftris)
            }
            scene.playSound(sound: "Sounds/bomb.mp3")
        } else {
            nextShape()
        }
    
    
    }
    
    // #17 after a shape has being moved, its representative sprites must be redrawn at their new locations
    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(shape: swiftris.fallingShape!) {}
    }

}
