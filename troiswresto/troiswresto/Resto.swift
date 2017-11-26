//
//  Resto.swift
//  troiswresto
//
//  Created by etudiant21 on 06/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

class Resto: NSObject, MKAnnotation {
    let restoId: String
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var address: String
    var niceDescription: String
    var picture: UIImage?
    var pictureURL: String?
    var price: String
    var averageGrade: Float?
    
    init (restoId: String, title: String?, coordinate: CLLocationCoordinate2D, address: String, description: String, picture: UIImage?, pictureURL: String?, price: String, averageGrade: Float) {
        self.restoId = restoId
        self.title = title
        self.coordinate = coordinate
        self.address = address
        self.niceDescription = description
        self.picture = picture
        self.pictureURL = pictureURL
        self.price = price
        self.averageGrade = averageGrade
    }
}
