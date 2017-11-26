//
//  MapViewController.swift
//  troiswresto
//
//  Created by etudiant21 on 13/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addressMapLabel: UILabel!
    
    @IBOutlet weak var validateButton: UIButton!
    
    var myRestos: [Resto]!
    let regionRadius: CLLocationDistance = 2000
    let locationManager = CLLocationManager()
    var coordinate = CLLocation()
    
    @IBAction func validateButtonPressed(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createResto") as? CreateRestoViewController {
            if let navigator = self.navigationController {
                viewController.realAddress = addressMapLabel.text
                viewController.coordinate = CLLocationCoordinate2D(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude)
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initUserLocation()
        
        validateButton.layer.borderWidth = 2
        validateButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        validateButton.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.7932096912, alpha: 1)
        validateButton.layer.cornerRadius = 4.5
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.addAnnotations(myRestos)
        
        for myResto in myRestos {
            print ("Voici mes restos: \(myResto.title)")
        }
        
        centerMap(on: .init(latitude: 48.893908, longitude: 2.354320), mapView: mapView, regionRadius: regionRadius)
        
        validateButton.isEnabled = false
        validateButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let resto = annotation as? Resto else {
            NSLog("L'annotation n'est pas de type resto")
            return nil
        }
        
        let identifier = "pin"
        var view: MKAnnotationView
        
        view = MKAnnotationView(annotation: resto, reuseIdentifier: identifier)
        
        view.centerOffset = CGPoint(x: 0, y: -17)
        view.canShowCallout = true
        
        view.image = #imageLiteral(resourceName: "station_grise")
        
        view.frame.size = CGSize(width: 30, height: 34)
        
        return view
    }
    
    // fonction de delegate pour intercepter le déplacement de la carte
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("region did change")
        let x = mapView.region.center.latitude
        let y = mapView.region.center.longitude
        coordinate = CLLocation.init(latitude: x, longitude: y)
        getAdressFromLocation(coordinate, completion: {output in
            self.addressMapLabel.text = output
            if self.addressMapLabel.text != "" {
                self.validateButton.isEnabled = true
                self.validateButton.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.7932096912, alpha: 1)
            } else {
                self.validateButton.isEnabled = false
                self.validateButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        })
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    @IBAction func centerOnUserButtonPressed() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    // ajouter dans la classe la variable
    // let locationManager = CLLocationManager()
    
    
    func initUserLocation() {
        locationManager.delegate = self
        
        // définition de la précision
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // demande d'autorisation
        // attention, ajouter le paramètre dans Info.plist
        /*
         <key>NSLocationWhenInUseUsageDescription</key>
         <string>My Velib will need your location</string>
         
         */
        
        locationManager.requestWhenInUseAuthorization()
        
        // demarrage de la loc
        locationManager.startUpdatingLocation()
        
        
        self.mapView.showsUserLocation = true
    }
}
