//
//  GameScene.swift
//  AngryBirdClone
//
//  Created by Ahmet Emin Yalçınkaya on 22.03.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	//var bird2=SKSpriteNode()
	var bird = SKSpriteNode()
	var boxes = [SKSpriteNode]()
	
	var gameStarded = false
	var originalPosition : CGPoint?
	var score = 0
	var scoreLabel = SKLabelNode()
	
	
	var CollisionSound = SKAction.playSoundFileNamed("collision", waitForCompletion: false)
	
	enum ColliderType: UInt32 {
		case Bird = 1
		case Box = 2
		//case Ground = 4
	}
	
	
	override func didMove(to view: SKView) {
		
		/*
		 let birdTexture=SKTexture(imageNamed: "bird")
		 bird2 = SKSpriteNode(texture: birdTexture)
		 bird2.position = CGPoint(x: 0, y: 0)
		 bird2.size = CGSize(width: self.frame.width/32, height: self.frame.height/20)
		 bird2.zPosition = 1
		 self.addChild(bird2)
		 */
		
		
		self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		self.scene?.scaleMode = .aspectFit
		self.physicsWorld.contactDelegate = self
		
		//Bird
		bird = childNode(withName: "bird") as! SKSpriteNode
		
		let birdTexture=SKTexture(imageNamed: "bird")
		
		bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
		bird.physicsBody?.affectedByGravity = false
		bird.physicsBody?.isDynamic = true
		bird.physicsBody?.mass = 0.2
		bird.physicsBody?.allowsRotation = true
		originalPosition = bird.position
		
		bird.physicsBody?.contactTestBitMask = ColliderType.Box.rawValue
		bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
		bird.physicsBody?.collisionBitMask = ColliderType.Box.rawValue
		
		
		
		
		//Box
		
		let boxTexture = SKTexture(imageNamed: "brick")
		let size = CGSize(width: boxTexture.size().width/7, height: boxTexture.size().height/7)
		
		// Düğümleri döngü içinde işle
		for i in 1...7 {
			if let boxNode = childNode(withName: "box\(i)") as? SKSpriteNode {
				boxNode.physicsBody = SKPhysicsBody(rectangleOf: size)
				boxNode.physicsBody?.affectedByGravity = true
				boxNode.physicsBody?.isDynamic = true
				boxNode.physicsBody?.mass = 0.02
				boxNode.physicsBody?.allowsRotation = true
				boxNode.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
				boxes.append(boxNode) // Düğümü diziye ekle
			} else {
				print("Hata: box\(i) düğümü bulunamadı veya dönüştürülemedi.")
			}
		}
		
		
		//label
		scoreLabel.fontName = "Helvetica"
		scoreLabel.fontSize = 60
		scoreLabel.text = " 0"
		scoreLabel.position = CGPoint(x: 0, y: 120)
		scoreLabel.zPosition = 2
		self.addChild(scoreLabel)
		
		
		
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		if contact.bodyA.collisionBitMask == ColliderType.Bird.rawValue || contact.bodyB.collisionBitMask == ColliderType.Bird.rawValue {
			//print("Collision")
			self.run(CollisionSound)
			score += 1
			scoreLabel.text = " \(score)"
		}
	}
	
	
	func touchDown(atPoint pos : CGPoint) {
			
		
		
		
	}
	
	func touchMoved(toPoint pos : CGPoint) {
		
		
		 
		
	}
	
	func touchUp(atPoint pos : CGPoint) {
		

		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		//bird.physicsBody?.affectedByGravity = true
		//bird.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 100))
		
		if gameStarded == false {
			if let touch = touches.first  {
				let touchLocation = touch.location(in: self)
				let touchNodes = nodes(at: touchLocation)
				
				if touchNodes.isEmpty == false{
					
					for node in touchNodes {
						if let sprite = node as? SKSpriteNode {
							if sprite == bird {
								bird.position = touchLocation
							}
						}
					}
	
					
				}
			}
			
			
			
		}
		
		
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		
		
		
		if gameStarded == false {
			if let touch = touches.first  {
				let touchLocation = touch.location(in: self)
				let touchNodes = nodes(at: touchLocation)
				
				if touchNodes.isEmpty == false{
					
					for node in touchNodes {
						if let sprite = node as? SKSpriteNode {
							if sprite == bird {
								bird.position = touchLocation
							}
						}
					}
	
					
				}
			}
			
			
			
		}
		
		
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		
		if gameStarded == false {
			if let touch = touches.first  {
				let touchLocation = touch.location(in: self)
				let touchNodes = nodes(at: touchLocation)
				
				if touchNodes.isEmpty == false{
					
					for node in touchNodes {
						if let sprite = node as? SKSpriteNode {
							if sprite == bird {
								let dx = -(touchLocation.x - originalPosition!.x)
								let dy = -(touchLocation.y - originalPosition!.y)
								let impulse = CGVector(dx: dx, dy: dy)
								bird.physicsBody?.applyImpulse(impulse)
								bird.physicsBody?.affectedByGravity = true
								gameStarded = true
							}
						}
					}
	
					
				}
			}
			
			
			
		}
	  
		
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
	   
		
		
	}
	
	
	override func update(_ currentTime: TimeInterval) {
		
		if let birdPhysicsBody = bird.physicsBody {
			
			if birdPhysicsBody.velocity.dx <= 0 && birdPhysicsBody.velocity.dy == 0 && birdPhysicsBody.angularVelocity <= 0 && gameStarded == true {
				bird.physicsBody?.affectedByGravity = false
				bird.position = originalPosition!
				gameStarded = false
	
			}
		}
		
		
	}
}
