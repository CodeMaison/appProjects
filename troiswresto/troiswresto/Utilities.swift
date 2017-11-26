//
//  Utilities.swift
//  troiswresto
//
//  Created by etudiant21 on 08/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation
import MapKit

// Alerts

func presentMessage (title1: String, message: String, title2: String, controller: UIViewController, myCompletion: @escaping (Bool) -> Void) {
    let alertController = UIAlertController(title: title1, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: title2, style: .default, handler: {result in
        // controller.navigationController?.popToRootViewController(animated: true)
        myCompletion(true)
        NSLog("Le bouton OK a été cliqué")}))
    controller.present(alertController, animated: true, completion: nil)
}

/*func presentMessageSecond (title1: String, message: String, title2: String, controller: UIViewController) {
    let alertController = UIAlertController(title: title1, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: title2, style: .default, handler: {result in
        NSLog("Le bouton OK a été cliqué")}))
    controller.present(alertController, animated: true, completion: nil)
}*/

// Alamofire

func getImage (urlString: String, myCompletion: @escaping (UIImage?) -> Void) {
    Alamofire.request(urlString).responseData { response in
        if let data = response.result.value {
            let image = UIImage(data: data)
            myCompletion(image)
        } else {
            print ("La response est nulle")
            myCompletion(nil)
        }
    }
}

// fonction pour obtenir une adresse à partir d'une location
// location est une CLLocation

func getAdressFromLocation (_ location : CLLocation, completion:@escaping (String)->Void ) {
    
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        var output = ""
        guard error == nil && placemarks != nil && placemarks!.count > 0 else {
            print("Reverse geocoder failed with error" + error!.localizedDescription)
            completion("")
            return
        }
        
        if placemarks!.count > 0 {
            let pm = placemarks![0] as CLPlacemark
            if pm.thoroughfare != nil && pm.subThoroughfare != nil && pm.postalCode != nil && pm.locality != nil {
                output =  pm.subThoroughfare! + " " + pm.thoroughfare! + " " + pm.postalCode! + " " + pm.locality!
            } else {
                output = ""
            }
        } else {
            output = ""
        }
        completion(output)
    })
}

// Center map

func centerMap(on location: CLLocationCoordinate2D, mapView: MKMapView, regionRadius: CLLocationDistance) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: false)
}
