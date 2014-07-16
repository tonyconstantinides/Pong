//
//  GameViewController.swift
//  Pong
//
//  Created by Tony Constantinides on 7/11/14.
//  Copyright (c) 2014 Tony Constantinides. All rights reserved.
//

import UIKit
import SpriteKit


extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
 
        var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        return scene
    }
}


class GameViewController: UIViewController {
    let log = XCGLogger.defaultInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        log.debug("Executing viewDidLoad")
        
        log.debug("Loading the Scene file")
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            log.debug("Setting up the Vew")
            // Configure the view.
            let skView = self.view as SKView
            // Set the background color and title
            skView.backgroundColor = UIColor.blackColor()

            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .Fill
            
            //log.debug("About to show the scene")
            skView.presentScene(scene)
        }

}

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }


}
