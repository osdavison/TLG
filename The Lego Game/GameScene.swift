//
//  GameScene.swift
//  The Lego Game
//
//  Created by Seth Davison on 2/25/16.
//  Copyright (c) 2015 Seth Davison. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
   
   let redTeam = Team.Red
   let blueTeam = Team.Blue
   var blueTurn = true
   
   var redArmy = Army()
   var blueArmy = Army()
   
   var blueTrooper = Soldier()
   var redTrooper = Jedi()
   
   var moveTotal = 0
   var attackTotal = 0
   
   var selectedSoldier: Soldier = Soldier()
   
   var buttonList: Array<SKLabelNode> = Array()
   
   var restartGameButton: SKLabelNode = SKLabelNode()
   var endTurnButton: SKLabelNode = SKLabelNode()
   var moveLabel: SKLabelNode = SKLabelNode()
   var attackLabel: SKLabelNode = SKLabelNode()
   
   
   
   //Sprite sizes
   let spriteSizeX = 54
   let spriteSizeY = 80
   let spritex2SizeX = 108
   let spritex2SizeY = 160
   
   override func didMoveToView(view: SKView) {
      /* Setup your scene here */
      backgroundColor = SKColor.grayColor()
      
      let topBar = SKSpriteNode(imageNamed: "Black")
      topBar.position = CGPoint(x: size.width / 2, y: 9 * size.height / 10)
      
      //addChild(topBar)
      redArmy = Army(name: "redArmy", team: redTeam)
      blueArmy = Army(name: "blueArmy", team: blueTeam)
      blueTrooper = Soldier(name: "blueTrooper", team: blueTeam, army: blueArmy, sprite: SKSpriteNode(imageNamed: "CloneCommandoBlue"), scene: self)
      let forcePowers: Array<Force> = [Force.Choke, Force.Lightning, Force.SaberThrow]
      redTrooper = Jedi(name: "redTrooper", team: redTeam, army: redArmy, sprite: SKSpriteNode(imageNamed: "CloneCommandoRed"), scene: self, forcePowers: forcePowers)
      
      addLabel("Blue Base", position: CGPoint(x: size.width / 20, y: size.height / 2 - 70))
      addLabel("Blue Back Trench", position: CGPoint(x: 2 * size.width / 10, y: size.height / 2 - 70))
      addLabel("Blue Top Outpost", position: CGPoint(x: 3 * size.width / 10, y: 2 * size.height / 3 - 70))
      addLabel("Blue Bottom Outpost", position: CGPoint(x: 3 * size.width / 10, y: size.height / 3 - 70))
      addLabel("Blue Front Trench", position: CGPoint(x: 4 * size.width / 10, y: size.height / 2 - 70))
      addLabel("No Man's Land", position: CGPoint(x: 5 * size.width / 10, y: size.height / 2 - 50))
      addLabel("Red Front Trench", position: CGPoint(x: 6 * size.width / 10, y: size.height / 2 - 70))
      addLabel("Red Bottom Outpost", position: CGPoint(x: 7 * size.width / 10, y: size.height / 3 - 70))
      addLabel("Red Top Outpost", position: CGPoint(x: 7 * size.width / 10, y: 2 * size.height / 3 - 70))
      addLabel("Red Back Trench", position: CGPoint(x: 8 * size.width / 10, y: size.height / 2 - 70))
      addLabel("Red Base", position: CGPoint(x: 19 * size.width / 20, y: size.height / 2 - 70))
      
      restartGameButton =  addLabel("Restart Game", position: CGPoint(x: 1 * size.width / 10, y: 8 * size.height / 10))
      buttonList.append(restartGameButton)
      
      endTurnButton =  addLabel("End Turn", position: CGPoint(x: 9 * size.width / 10, y: 8 * size.height / 10))
      buttonList.append(endTurnButton)
      
      moveLabel =  addLabel("Move: 0", position: CGPoint(x: 4 * size.width / 10, y: 8 * size.height / 10))
      attackLabel =  addLabel("Attack: 0", position: CGPoint(x: 6 * size.width / 10, y: 8 * size.height / 10))
      
   }
   
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
      /* Called when a touch begins */
   }
   
   override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
      
      guard let touch = touches.first else {
         return
      }
      
      let touchLocation = touch.locationInNode(self)
      
      //Check if the touch was on the blue trooper sprite
      if (blueTrooper.sprite.containsPoint(touchLocation)) {
         touchedSoldier(blueTrooper)
      } else if (redTrooper.sprite.containsPoint(touchLocation)) {
         touchedSoldier(redTrooper)
      }else if restartGameButton.containsPoint(touchLocation){
            self.removeAllChildren()
            didMoveToView(self.view!)
            diceRoll(&moveTotal, attackTotal: &attackTotal)
            selectedSoldier = Soldier()
      } else if (endTurnButton.containsPoint(touchLocation)) { //Swap turns
         blueTurn = !blueTurn
         diceRoll(&moveTotal, attackTotal: &attackTotal)
         print("Is it blue's turn?", blueTurn)
      }
   }
   
   override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
   }
   
   func touchedSoldier(soldier: Soldier) {
      
      //If its blue's turn
      if (blueTurn) {
         
         //If the tapped soldier is blue
         if (soldier.team == Team.Blue) {
            selectedSoldier = soldier
            
         } else if (soldier.team == redTeam) { //If the tapped soldier is red
            
            if (selectedSoldier.team == Team.Blue) {
               selectedSoldier.attack(soldier, attackTotal: &attackTotal, scene: self)
               setLabelText(attackLabel, text: "Attack: \(attackTotal)")
            }
         }
         
         //If we haven't selected any soldier yet and the tap was on a blue trooper
         if (selectedSoldier.team == Team.Default) {
            selectedSoldier = soldier
         } else if (selectedSoldier.team == redTeam) {
            //FIXME
         }
         
      } else { //If it's red's turn
         
         //If the tapped soldier is red
         if (soldier.team == redTeam) {
            selectedSoldier = soldier
            
         } else if (soldier.team == Team.Blue) { //If the tapped soldier is blue
            
            if (selectedSoldier.team == redTeam) {
               selectedSoldier.attack(soldier, attackTotal: &attackTotal, scene: self)
               setLabelText(attackLabel, text: "Attack: \(attackTotal)")
            }
         }
         
         //If we haven't selected any soldier yet and the tap was on a red trooper
         if (selectedSoldier.team == Team.Default) {
            selectedSoldier = soldier
         } else if (selectedSoldier.team == Team.Blue) {
            //FIXME
         }
      }
   }
   
   func touchedLocation(location: Location) {
      
      if selectedSoldier.team != Team.Default {
         selectedSoldier.moveTo(location, moveTotal: &moveTotal)
      }
      
   }
   
   func diceRoll(inout moveTotal: Int, inout attackTotal: Int) {
      moveTotal = Int(arc4random_uniform(20)) + 1
      attackTotal = Int(arc4random_uniform(19)) + 2
      setLabelText(moveLabel, text: "Move: \(moveTotal)")
      setLabelText(attackLabel, text: "Attack: \(attackTotal)")
      
      
   }
   
   func isInBox (point: CGPoint, boxUR: CGPoint, boxLL: CGPoint)-> Bool {
      if ((point.x < boxUR.x) && (point.x > boxLL.x) && (point.y < boxUR.y) && (point.y > boxLL.y)) {
         return true
      } else {
         return false
      }
   }
   
   func addLabel(text: String, position: CGPoint, font: String = "SanFranciscoDisplay-Black", fontSize: CGFloat = 20, fontColor: UIColor = SKColor.whiteColor())-> SKLabelNode {
      let label = SKLabelNode(fontNamed: font)
      label.text = text
      label.fontSize = fontSize
      label.fontColor = fontColor
      label.position = position
      addChild(label)
      return label
   }
   
   func setLabelText(label: SKLabelNode, text: String) {
      
      label.removeFromParent()
      label.text = text
      addChild(label)
      
   }
}


//Operators for vectors and points

