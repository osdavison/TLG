//
//  Army.swift
//  TheLegoGame
//
//  Created by Seth Davison on 11/18/15.
//  Copyright © 2015 Seth Davison. All rights reserved.
//

import Foundation

public class Army {
   
   //Public
   
   //Instance-specific
   var name: String
   var team: Team
   var soldiers: [Soldier] = []
   
   init() {
      name = "Default"
      team = Team.Default
   }
   
   init(name: String, team: Team) {
      self.name = name
      self.team = team
   }
   
   func printAttributes() {
      print("Name: \(name); Team: \(team)")
      
      for soldier in soldiers {
         print("Soldier: \(soldier.getName())")
      }
   }
   
   //Add a soldier to this army
   func addSoldier(soldier: Soldier) {
      
      var duplicateName = false
      
      //Check for duplicates or a blank name
      for person in soldiers {
         if ((person.getName() == soldier.getName()) || soldier.getName().isEmpty) {
            duplicateName = true
            break
         }
      }
      
      //If the soldier's name is unique, add it to the list
      if !duplicateName {
         soldiers.append(soldier)
      }
   }
   
   //Add a soldier to this army
   func removeSoldier(soldier: Soldier) {
      
      var index: Int = 0
      var foundIndex: Int = -1
      
      //Check to see if the specified soldier is part of this army
      for person in soldiers {
         if (person.getName() == soldier.getName()) {
            foundIndex = index
            break
         }
         index += 1
      }
      
      if foundIndex > 0 {
         soldiers.removeAtIndex(foundIndex)
      }
   }
   
   //Private
}