//
//  PersistanceHelper.swift
//  myVelib
//
//  Created by etudiant21 on 30/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation


class PersistanceHelper {
    
    
    static func addFavoriteStationId (value: Int) {
        var myFavoriteStations = getFavoriteStationsId()
        if myFavoriteStations.contains(value) == false {
            myFavoriteStations.append(value)
            UserDefaults.standard.set(myFavoriteStations, forKey: "myVelibFavoriteStationsId")
        } else {
            NSLog("Cette station existait déjà")
        }
        
    }
    
    static func getFavoriteStationsId () -> [Int] {
        if let myArray = UserDefaults.standard.array(forKey: "myVelibFavoriteStationsId") as? [Int] {
            return myArray
        } else {
            return [Int] ()
        }
        
    }
    
    static func removeFavoriteStationId (value: Int) {
        var myFavoriteStations = getFavoriteStationsId()
        if let index = myFavoriteStations.index(of: value) {
            myFavoriteStations.remove(at: index)
            UserDefaults.standard.set(myFavoriteStations, forKey: "myVelibFavoriteStationsId")
        } else {
            NSLog("Cette station n'existait pas dans le tableau")
        }
    }
    
}
