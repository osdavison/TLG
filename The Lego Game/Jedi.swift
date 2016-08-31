//
//  Jedi.swift
//  The Lego Game
//
//  Created by Seth Davison on 2/11/16.
//  Copyright © 2016 Seth Davison. All rights reserved.
//

import Foundation
import SpriteKit

public enum Force: Int {
   case Lightning = 0
   case Choke
   case SaberThrow
   case Default
}

public class Jedi: Soldier {
   
   // private inherited variables
   //private var name: String
   //private var team: Team
   //private var parentArmy: Army
   //private var positionX: Int
   //private var positionY: Int
   //private var health = 10
   //private var attack = 5
   //private var range = 5
   //private var dead = false
   private var forcePowers: Array<Force>
   
   //Public FIXME: make a sprite for the jedi
   //public var sprite = SKSpriteNode(imageNamed: "CloneCommando@x2")
   override init() {
      forcePowers = Array<Force>()
      
      super.init()
   }
   
   init(name: String, team: Team, army: Army, sprite: SKSpriteNode, scene: SKScene, forcePowers: Array<Force>, health: Int = 10, attack: Int = 5) {
      
      self.forcePowers = forcePowers
      
      super.init(name: name, team: team, army: army, sprite: sprite, scene: scene, health: health, attack: attack)
   }
   
   func setForcePowers(forcePowers: Array<Force>) {
      self.forcePowers = forcePowers
   }
   func getForcePowers()->Array<Force> {
      return self.forcePowers
   }
   
   func useForceLightning(enemies: [Soldier], inout attackTotal: Int) {
      if enemies.count > 3 || enemies.count < 1 {
         print("Error: You can only attack three enemies with force lightning.")
         return
      }
      
      for enemy in enemies {
         if enemy.team == self.team || !isInRange(enemy) {
            print("Error: The attacked soldier is either out of range or on your team")
            return
         }
         
         //Attack the enemy
         enemy.health = enemy.health - self.attack
         attackTotal -= 2
         
         //If the attack kills the enemy, set the health to an even 0, set dead to true, and move the enemy to the out of bounds location
         if enemy.health <= 0 {
            enemy.health = 0
            enemy.dead = true
            enemy.setLocation(Location.OutOfBounds)
         }
      }
   }
   
   
   
   
   
   
   
   
   
   
}