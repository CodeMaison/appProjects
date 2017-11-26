//
//  Utilities.swift
//  myVelib
//
//  Created by etudiant21 on 31/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation
import Amplitude_iOS

class Utilities {
    
    static func logEvent(name: String, parameters:[String: Any]? = nil) {
        Amplitude.instance().logEvent(name, withEventProperties: parameters)
    }
    
}
