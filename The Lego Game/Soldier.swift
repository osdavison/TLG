//
//  Soldier.swift
//  TheLegoGame
//
//  Created by Seth Davison on 2/25/16.
//  Copyright © 2015 Seth Davison. All rights reserved.
//

import Foundation
import SpriteKit

//Game board boundaries
let gameBoundsUpperX = 50
let gameBoundsLowerX = 0
let gameBoundsUpperY = 20
let gameBoundsLowerY = 0

let redStartPosX = 0
let redStartPosY = 0
let blueStartPosX = gameBoundsUpperX
let blueStartPosY = 0

public enum Team: Int {
   case Red = 0
   case Blue = 1
   case Default = 2
}

public enum Location: Int {
   case BlueBase = 0
   case BlueTrenchBack = 1
   case BlueTrenchFront = 2
   case BlueOutpostTop = 3
   case BlueOutpostBottom = 4
   case NoMansLand = 5
   case RedOutpostBottom = 6
   case RedOutpostTop = 7
   case RedTrenchFront = 8
   case RedTrenchBack = 9
   case RedBase = 10
   case OutOfBounds = 11
   case Default = 12
   
}

public class Soldier {
   
   public var name: String
   public var team: Team
   public var parentArmy: Army
   private var location: Location
   public var health = 10
   public var attack = 5
   public var range = 5
   public var dead = false
   public var busy = false
   public var locationPoints: [Location:CGPoint] = [Location.BlueBase : CGPoint(x: 50, y: 120), Location.BlueTrenchBack : CGPoint(x: 200, y: 120), Location.BlueTrenchFront : CGPoint(x: 400, y: 120), Location.BlueOutpostTop : CGPoint(x: 300, y: 150), Location.BlueOutpostBottom : CGPoint(x: 300, y: 110), Location.NoMansLand : CGPoint(x: 800, y: 120), Location.RedOutpostBottom : CGPoint(x: 130, y: 110), Location.RedOutpostTop : CGPoint(x: 1300, y: 50), Location.RedTrenchFront : CGPoint(x: 1300, y: 120), Location.RedTrenchBack : CGPoint(x: 1500, y: 120), Location.RedBase : CGPoint(x: 1700, y: 120)]
   
   public var sprite = SKSpriteNode(imageNamed: "CloneCommandoGeneric")
   
   //Instance-specific
   //Initializer
   init() {
      name = "DefaultSoldier"
      team = Team.Default
      parentArmy = Army()
      location = Location.OutOfBounds
      sprite.position = CGPoint(x: 50, y: 50)
   }
   
   init(name: String, team: Team, army: Army, sprite: SKSpriteNode, scene: SKScene, location: Location = Location.Default, health: Int = 10, attack: Int = 5) {
      self.name = name
      self.health = health
      self.attack = attack
      self.team = team
      self.parentArmy = army
      self.sprite = sprite
      
      locationPoints = [Location.BlueBase : CGPoint(x: scene.size.width / 20, y: scene.size.height / 2),
                        Location.BlueTrenchBack : CGPoint(x: 2 * scene.size.width / 10, y: scene.size.height / 2),
                        Location.BlueOutpostTop : CGPoint(x: 3 * scene.size.width / 10, y: 2 * scene.size.height / 3),
                        Location.BlueOutpostBottom : CGPoint(x: 3 * scene.size.width / 10, y: scene.size.height / 3),
                        Location.BlueTrenchFront : CGPoint(x: 4 * scene.size.width / 10, y: scene.size.height / 2),
                        Location.NoMansLand : CGPoint(x: 5 * scene.size.width / 10, y: scene.size.height / 2),
                        Location.RedTrenchFront : CGPoint(x: 6 * scene.size.width / 10, y: scene.size.height / 2),
                        Location.RedOutpostBottom : CGPoint(x: 7 * scene.size.width / 10, y: scene.size.height / 3),
                        Location.RedOutpostTop : CGPoint(x: 7 * scene.size.width / 10, y: 2 * scene.size.height / 3),
                        Location.RedTrenchBack : CGPoint(x: 8 * scene.size.width / 10, y: scene.size.height / 2),
                        Location.RedBase : CGPoint(x: 19 * scene.size.width / 20, y: scene.size.height / 2),
                        Location.OutOfBounds : CGPoint(x: 0, y: 0)]
      
      //Set the initial position
      if location != Location.Default {
         self.location = location
      } else if team == Team.Blue {
         self.location = Location.BlueBase
      } else if team == Team.Red{
         self.location = Location.RedBase
      } else {
         self.location = Location.OutOfBounds
      }
      
      self.sprite.position = locationPoints[self.location]!
         
      scene.addChild(self.sprite)
      
      //Do this last after all initialization is completed
      army.addSoldier(self)
   }
   
   //Getters/Setters
   func setName(name: String) {
      self.name = name
   }
   func getName()->String {
      return name
   }
   
   func setTeam(team: Team) {
      self.team = team
   }
   func getTeam()->Team {
      return team
   }
   
   func setParentArmy(parentArmy: Army) {
      
      //Remove the soldier from its current army
      self.parentArmy.removeSoldier(self)
      self.parentArmy = parentArmy
      
      //And add it to the new army
      self.parentArmy.addSoldier(self)
   }
   func getParentArmy()->Army {
      return parentArmy
   }
   
   func setLocation(location: Location) {
      var infiniteMove = 9999999
      moveTo(location, moveTotal: &infiniteMove)
   }
   func getLocation()->Location {
      return location
   }
   
   func setHealth(health: Int) {
      self.health = health
   }
   func getHealth()->Int {
      return health
   }
   
   func setAttack(attack: Int) {
      self.attack = attack
   }
   func getAttack()->Int {
      return attack
   }
   
   func setRange(range: Int) {
      self.range = range
   }
   func getRange()->Int {
      return range
   }
   
   func setDead(isDead: Bool) {
      self.dead = isDead
      
      //If we are setting the soldier to dead, move it out of bounds
      if isDead {
         location = Location.OutOfBounds
      }
   }
   func getDead()->Bool {
      return dead
   }
   
   func swapBusy() {
      busy = !busy
   }
   
   //Functions
   func printAttributes() {
      print("Name: \(name); Team: \(team); parentArmy: \(parentArmy.name)")
      
   }
   
   func printStats() {
      print("Name: \(name); Health: \(health); Attack: \(attack); Location: \(location)); Position: \(sprite.position) Dead: \(dead)")
   }
   
   func printStats(inout node: UILabel) {
      node.text = "Name: \(name); Health: \(health); Attack: \(attack); Position (X, Y) (\(location), Dead: \(dead)"
   }
   
   func isInRange(enemy: Soldier)->Bool {
      //if location == enemy.location { FIXME
         return true
      //} else {
         //return false
      //}
   }
   
   func isOutOfBounds()->Bool {
      if location == Location.OutOfBounds {return true} else {return false}
   }
   
   func isOutOfBounds(location: Location)->Bool {
      if location == Location.OutOfBounds {return true} else {return false}
   }
   
   //Find the distance between the current position and a destination
   func findDistance(destination: Location)->Int {
      //FIXME
      return 5
   }
   
   //attacks an enemy soldier, implements checks
   func attack(enemy: Soldier, inout attackTotal: Int, scene: SKScene) {
      if self.dead {
         print("You're trying to use a dead trooper")
      }
      if (enemy.team == self.team) || !(isInRange(enemy)) || (attackTotal < 2) {
         print("The attacked soldier is either out of range or on your team, or you don't have enough attack")
         return
      }
      
      //If not busy
      if (self.busy || enemy.busy) {
         return
      }
      
      //Turn on busy flag
      swapBusy()
      
      var laser: SKSpriteNode
      
      //Attack the enemy
      if team == Team.Blue {
         laser = SKSpriteNode(imageNamed: "BlueLaser")
      } else {
         laser = SKSpriteNode(imageNamed: "RedLaser")
      }
      
      laser.position = CGPoint(x: self.sprite.position.x + 20, y: self.sprite.position.y)
      
      scene.addChild(laser)
      
      laser.runAction(
         SKAction.sequence([
            SKAction.moveTo(enemy.sprite.position, duration: NSTimeInterval(2)),
            SKAction.removeFromParent(),
            SKAction.runBlock({self.swapBusy()})
         ])
      )
      
      enemy.health = enemy.health - self.attack
      attackTotal -= 2
      
      //If the attack kills the enemy, set the health to an even 0, set dead to true, and move the enemy to the out of bounds location
      if enemy.health <= 0 {
         
         enemy.swapBusy()
         
         //Wait for a second, then change to dead sprite
         if enemy.team == Team.Red {
            enemy.sprite.runAction(
               SKAction.sequence([
                  SKAction.waitForDuration(2),
                  SKAction.rotateToAngle(-3.14159 / 2, duration: 1),
                  SKAction.fadeOutWithDuration(0.5),
                  SKAction.moveTo(CGPoint(x: 999, y: 999), duration: 0.01),
                  SKAction.removeFromParent(),
                  SKAction.runBlock({enemy.swapBusy()})
               ])
            )
         } else {
            enemy.sprite.runAction(
               SKAction.sequence([
                  SKAction.waitForDuration(2),
                  SKAction.rotateToAngle(3.14159 / 2, duration: 1),
                  SKAction.fadeOutWithDuration(0.5),
                  SKAction.moveTo(CGPoint(x: 999, y: 999), duration: 0.01),
                  SKAction.removeFromParent(),
                  SKAction.runBlock({enemy.swapBusy()})
               ])
            )
         }
         enemy.health = 0
         enemy.dead = true
         enemy.setLocation(Location.OutOfBounds)
      }
   }
   
   //Move the soldier a certain number of spaces, implements checks
   func move(xAxis: Int, yAxis: Int, inout moveTotal: Int) {
      
      //If dead or if out of bounds or if the amount of move is too much, cancel the movement
      if self.dead || isOutOfBounds() || ((xAxis + yAxis) > moveTotal) {
         print("Soldier is out of Bounds or dead or we don't have enough move and cannot move")
         return
      } else {
         //FIXME
         //Sleep until not busy
         if self.busy {
            return
         }
         
         swapBusy()
         
         
         //Do action
         
         swapBusy()
         
         
      }
   }
   
   //Move the soldier to a specific location
   func moveTo(destination: Location, inout moveTotal: Int) {
      
      //Get the distance between the current position and the destination
      let distance = findDistance(destination)
      
      //If there is enough move left to get there and the destination is in bounds
      if (moveTotal - distance >= 0) && (!isOutOfBounds(destination)) {
         
         
         //If not dead and if not out of bounds
         if  self.dead || isOutOfBounds() {
            print("Soldier is out of bounds or dead and cannot move")
            return
         }
         else {
            //Decrease the moveTotal by the appropiate amount and move the soldier to the destination
            //If not busy
            if self.busy {
               return
            }
            
            swapBusy()
            
            moveTotal -= distance
            location = destination
            sprite.runAction(
               SKAction.sequence([
               SKAction.moveTo(locationPoints[destination]!, duration: NSTimeInterval(1)),
                  SKAction.runBlock({self.swapBusy()})
               ])
            )
         }
      }
   }
}