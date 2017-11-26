//
//  Parameters.swift
//  myVelib
//
//  Created by etudiant21 on 24/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation

class Parameters {
    
    static let apiKey = "37335fa3312241e87c42d17dc79b5f4057e84e93"
    static var contract = UserDefaults.standard.string(forKey: "myVelibVilleSelectionnee") ?? "Paris"
}

