//
//  GameScene.swift
//  Pong
//
//  Created by Tony Constantinides on 7/11/14.
//  Copyright (c) 2014 Tony Constantinides. All rights reserved.
//

import SpriteKit
import CoreGraphics


class GameScene: SKScene, SKPhysicsContactDelegate  {
   let log = XCGLogger.defaultInstance()
    var  leftPaddle:SKSpriteNode  = SKSpriteNode(imageNamed: "white.png")
    var  rightPaddle:SKSpriteNode = SKSpriteNode(imageNamed: "white.png")
    var  middleLine:SKSpriteNode  = SKSpriteNode(imageNamed: "white.png")
    let  leftPaddleLabel = "leftPaddle"
    let  rightPaddleLabel = "rightPaddle"
    let  ceilingLabel     = "ceiling"
    let  floorLabel       = "floor"
    let  paddleHeight = 180.0
    let  ballSpeed    = 0.50
    let  paddleMoveSpeed = 0.3
    
    enum ColliderType: UInt32 {
        case leftPaddle = 1
        case rightPaddle = 2
        case ball = 4
        case floor = 8
        case ceiling = 16
        case pong = 32
    }
   
    
    override func didMoveToView(view: SKView!) {
        log.debug("didMoveToView")
        // Set the sccale mode to scale to fit the window
        setupScene()
        
        /* Setup your scene here */
        // we live in a world with gravity on the y axis
        addStructures()
        setupNet()
        setupRightPaddle()
        setupLeftPaddle()
        
        addSpritesToScene()
      }
    
    
    func setupScene() {
        view.scene.scaleMode =  SKSceneScaleMode.Fill
        view.scene.backgroundColor = UIColor(red: 0, green: 0.4, blue : 0.12, alpha: 1.0)
        // set the ball physics velocity bounce
        self.physicsWorld.gravity = CGVectorMake(-15,-20)
        // adjust the speed of the ball
        self.physicsWorld.speed = CGFloat(ballSpeed)
        // setup the contact delegte (colussion detection)
        self.physicsWorld.contactDelegate = self
      }
    
    func  addSpritesToScene() {
        self.addChild( leftPaddle )
        self.addChild( rightPaddle )
        self.addChild( middleLine )
    }
    
    func addStructures() {
        self.addChild(self.createFloor())
        self.addChild(self.createCeiling())
    }
    
    func setupNet() {
        let middleLinePosition = self.frame.midX
        middleLine.position = CGPoint(x:middleLinePosition, y:0)
        middleLine.size = CGSize(width: 10, height:self.frame.height)
        middleLine.anchorPoint = CGPoint(x:0.0, y:0.0)
        middleLine.xScale = 1.0
        middleLine.yScale = 1.0
        middleLine.zPosition = 2
    }
    
    func setupRightPaddle() {
        setupRightPaddleSprite()
        setupRightPaddleForMotion()
    }
    
    func setupRightPaddleSprite() {
        
        let rightPaddlePosition = (self.frame.width  - 5)
        rightPaddle.position = CGPoint(x:rightPaddlePosition, y:self.frame.height)
        rightPaddle.size = CGSize(width: 5, height: CGFloat(paddleHeight))
        rightPaddle.anchorPoint = CGPoint(x:0.0, y:0.0)
        rightPaddle.xScale = 1.0
        rightPaddle.yScale = 1.0
        rightPaddle.physicsBody = SKPhysicsBody(edgeLoopFromRect: rightPaddle.frame)
        rightPaddle.physicsBody.dynamic = false
        rightPaddle.physicsBody.friction = 0.0
        rightPaddle.physicsBody.restitution = 0.0
        rightPaddle.physicsBody.usesPreciseCollisionDetection = true
        rightPaddle.zPosition = 4
    }
    
    
    func setupRightPaddleForMotion() {
        let rightPaddlePosition = (self.frame.width - 5)
        let topAdjusted = CGFloat(self.frame.height) - CGFloat(paddleHeight)
        // hadle Left Paddle
        let upperRightLocation = CGPoint(x:rightPaddlePosition, y:topAdjusted)
        let lowerRightLocation = CGPoint(x:rightPaddlePosition, y:0)
        
        let moveUpRightPaddle = SKAction.moveTo(upperRightLocation, duration: paddleMoveSpeed)
        moveUpRightPaddle.timingMode = SKActionTimingMode.EaseOut
        
        let moveDownRightPaddle = SKAction.moveTo(lowerRightLocation, duration: paddleMoveSpeed)
        moveDownRightPaddle.timingMode = SKActionTimingMode.EaseOut
        
        let runRightPaddleSequence = SKAction.sequence([ moveUpRightPaddle, moveDownRightPaddle ])
        
        rightPaddle.runAction(SKAction.repeatActionForever(runRightPaddleSequence))
    }
    
    func setupLeftPaddle() {
        setupLeftPaddleSprite()
        setupLeftPaddleForMotion()
    }
    
    func setupLeftPaddleSprite() {
        leftPaddle.position = CGPoint(x:0,y:0)
        leftPaddle.size = CGSize(width: 5, height: CGFloat(paddleHeight))
        leftPaddle.anchorPoint = CGPoint(x:0.0,y:0.0)
        leftPaddle.xScale = 1.0
        leftPaddle.yScale = 1.0
        leftPaddle.physicsBody = SKPhysicsBody(rectangleOfSize: leftPaddle.frame.size)
        leftPaddle.physicsBody.dynamic = false
        leftPaddle.physicsBody.friction = 0.0
        leftPaddle.physicsBody.restitution = 0.0
        leftPaddle.physicsBody.usesPreciseCollisionDetection = true
        leftPaddle.zPosition = 3
    }

    func setupLeftPaddleForMotion()  {
        let topAdjusted = CGFloat(self.frame.height) - CGFloat(paddleHeight)
        // hadle Left Paddle
        let upperLeftLocation = CGPoint(x:0, y:topAdjusted)
        let lowerLeftLocation = CGPoint(x:0, y:0)
        
        let moveUpLeftPaddle = SKAction.moveTo(upperLeftLocation, duration: paddleMoveSpeed)
        moveUpLeftPaddle.timingMode = SKActionTimingMode.EaseOut
        
        let moveDownLeftPaddle = SKAction.moveTo(lowerLeftLocation, duration: paddleMoveSpeed)
        moveDownLeftPaddle.timingMode = SKActionTimingMode.EaseOut
        
        let runLeftPaddleSequence = SKAction.sequence([ moveUpLeftPaddle, moveDownLeftPaddle ])
        
        leftPaddle.runAction(SKAction.repeatActionForever(runLeftPaddleSequence))
    }
    
    
    func createCeiling() -> SKSpriteNode {
        let ceiling  = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(self.frame.size.width, 20))
        
        ceiling.anchorPoint = CGPointMake(0, 0)
        ceiling.name = "ceiling"
        ceiling.position = CGPointMake(0, self.frame.height - 20)
        ceiling.zPosition = 0
        ceiling.physicsBody = SKPhysicsBody(edgeLoopFromRect: ceiling.frame)
        ceiling.physicsBody.dynamic = false
        ceiling.physicsBody.friction = 0.0
        ceiling.physicsBody.restitution = 0.0
        ceiling.physicsBody.affectedByGravity = false
        // collision detection
        ceiling.physicsBody.usesPreciseCollisionDetection = true
        
        return ceiling
    }
    
    func createFloor() -> SKSpriteNode {
        let floor = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(self.frame.size.width, 20))
        
        floor.anchorPoint = CGPointMake(0, 0)
        floor.name = "floor"
        floor.position = CGPointMake(0, 0)
        floor.zPosition = 1
        floor.physicsBody = SKPhysicsBody(edgeLoopFromRect: floor.frame)
        floor.physicsBody.dynamic = false
        floor.physicsBody.friction = 0.0
        floor.physicsBody.restitution = 0.0
        floor.physicsBody.affectedByGravity = false
        // collision detection
        floor.physicsBody.usesPreciseCollisionDetection = true
        return floor
    }
    
    func createBall(position: CGPoint) -> SKShapeNode {
        let ball = SKShapeNode( circleOfRadius: 22.0)
        let positionMark = SKShapeNode(circleOfRadius: 6.0)
        
        ball.position = position
        ball.zPosition = 4
        ball.name = "ball"
        ball.fillColor = UIColor.whiteColor()
        
        // The physical engine settings for the ball
        ball.physicsBody = SKPhysicsBody( circleOfRadius: 22.0)
        ball.physicsBody.dynamic = true
        ball.physicsBody.friction = 0.1
        ball.physicsBody.restitution = 1.0
        ball.physicsBody.mass = 1.0
        ball.physicsBody.linearDamping = 0.0
        ball.physicsBody.resting = false
        ball.physicsBody.affectedByGravity = true
        ball.physicsBody.applyImpulse(CGVectorMake(10.0, 1.0))
        ball.physicsBody.angularVelocity = CGFloat(0.5)
        
        // this will allow the balls to rotate when bouncing off each other
        ball.physicsBody.allowsRotation = false
        ball.physicsBody.usesPreciseCollisionDetection = true
    
        // for collusioond detection
        ball.physicsBody.categoryBitMask = ColliderType.pong.toRaw()
        ball.physicsBody.collisionBitMask = ColliderType.floor.toRaw()
                                            | ColliderType.ceiling.toRaw()
                                            | ColliderType.rightPaddle.toRaw()
                                            | ColliderType.leftPaddle.toRaw()
        ball.physicsBody.contactTestBitMask = ColliderType.pong.toRaw()
                                            | ColliderType.floor.toRaw()
                                            | ColliderType.ceiling.toRaw()
                                            | ColliderType.rightPaddle.toRaw()
                                            | ColliderType.leftPaddle.toRaw()
        
        positionMark.position.y = -6
        ball.addChild(positionMark)
        
        return ball
    }
    
  
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            var ball:SKNode? = self.childNodeWithName("ball")
            if ball == nil {
                self.addChild(self.createBall(location))
            }
        }
    }
    
    func didBeginContact(contact:SKPhysicsContact!) {
        var bodyA:SKPhysicsBody = contact.bodyA
        var bodyB:SKPhysicsBody = contact.bodyB
        
    
        log.debug("**************************************")
        log.debug("Collision  detected: didBeginContact")
        log.debug("**************************************")
        if (contact.bodyA.categoryBitMask & 4 > 0 || contact.bodyB.categoryBitMask & 4 > 0 ) {
            log.debug("------------------------------------")
            log.debug("Executing custom collision logic")
            log.debug("------------------------------------")
            let ball = (contact.bodyA.categoryBitMask & 4) > 0 ?  contact.bodyA.node : contact.bodyB.node
            let floorNode =   self.childNodeWithName(floorLabel)
            let ceilingNode = self.childNodeWithName(ceilingLabel)
            let positionX = ball.position.x as NSNumber
            let positionY = ball.position.y as NSNumber
            var ballX:String = positionX.stringValue
            var ballY:String = positionY.stringValue
            var ballPosition:String  = "-->Bal x,y: " + ballX + "," + ballY
            // What did I find?
            if (ball.intersectsNode(leftPaddle)) {
                log.debug("--->Ball hit leftPaddle")
                log.debug(ballPosition)
               self.physicsWorld.gravity = CGVectorMake(15,20)
               ball.physicsBody.velocity = CGVectorMake( -ball.physicsBody.velocity.dx * 5,
                    -ball.physicsBody.velocity.dy * 2.0)
            }
            else if (ball.intersectsNode(rightPaddle)) {
                log.debug("--->Ball hit rightPaddle")
                log.debug(ballPosition)
                self.physicsWorld.gravity = CGVectorMake(-15,-20)
                ball.physicsBody.velocity = CGVectorMake( ball.physicsBody.velocity.dx * 2.5,
                    ball.physicsBody.velocity.dy * 2.0)
            }
            else if (floorNode != nil && ball.intersectsNode(floorNode)) {
                log.debug("--->Ball hit floor")
                log.debug(ballPosition)
            }
            else if (ceilingNode != nil && ball.intersectsNode(ceilingNode)) {
                log.debug("--->Ball hit ceiling")
                log.debug(ballPosition)
            }
            else if (ball.position.y >= (self.frame.width * 1.5) && ball.position.y >= 0) {
                log.debug("--->Ball bounces off lower right corner")
                log.debug(ballPosition)
            }
            else if ((ball.position.x >= self.frame.height * 1.5) && (ball.position.x >= 0) && (ball.position.y >= self.frame.width)) {
                log.debug("--->Ball bounces off upper right corner")
                log.debug(ballPosition)
            }
            
        }

    }

    func didEndContact(contact: SKPhysicsContact!) {
    }
    
    override func didSimulatePhysics() {
        
        let block: (SKNode!, UnsafePointer<ObjCBool>) -> Void  = { node, stop in
             
            if node.position.y < 0 {
                node.removeFromParent()
            }
            else if (node.position.x < 0) {
                node.removeFromParent()
            }
            else if (node.position.x > self.frame.width) {
                node.removeFromParent()
                self.physicsWorld.gravity = CGVectorMake(-15,-20)
            }
            else if (node.position.y > self.frame.height - 20) {
                node.position.y =   node.position.y - 30
                self.physicsWorld.gravity = CGVectorMake(-15,-20)
            }
         }
        
        self.enumerateChildNodesWithName("ball", usingBlock: block)
    }
    
}
