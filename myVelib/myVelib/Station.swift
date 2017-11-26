//
//  Station.swift
//  myVelib
//
//  Created by etudiant21 on 24/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Station: NSObject, MKAnnotation {
    let stationId: Int
    let title: String?
    let address: String
    let coordinate: CLLocationCoordinate2D
    let isOpened: Bool
    let contract: String
    let availableBikeStands: Int
    let availableBikes: Int
    var isFavorite = false
    
    init(stationId: Int, title: String, address: String, coordinate: CLLocationCoordinate2D, isOpened: Bool, contract: String, availableBikeStands: Int, availableBikes: Int) {
        self.stationId = stationId
        self.title = title.replaceElements(title: title)
        self.address = address
        self.coordinate = coordinate
        self.isOpened = isOpened
        self.contract = contract
        self.availableBikeStands = availableBikeStands
        self.availableBikes = availableBikes
        
        super.init()
    }

}

/*
 class StationPin: NSObject, MKAnnotation {
 let title: String?
 var station: Station
 
 
 init(station: Station) {
 self.station = station
 self.title = station.name
 
 super.init()
 }
 
 let image = #imageLiteral(resourceName: "station_orange")
 
 var coordinate : CLLocationCoordinate2D {
 return self.station.position
 }
 
 //nécessaire si on ne veut pas de subtitle
 var subtitle: String? = ""
 } */
