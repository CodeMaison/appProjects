//
//  MapViewController.swift
//  myVelib
//
//  Created by etudiant21 on 25/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables globales
    
    var myRealStations: [Station]!
    var mySelectedStation: Station?
    var myRealFavoriteStations: [Station]!
    let regionRadius: CLLocationDistance = 50
    var type: Int = 0
    let locationManager = CLLocationManager()
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func typeSegmentedControlPressed(_ sender: UISegmentedControl) {
        let segment = sender.selectedSegmentIndex
        switch segment{
        case 0:
            type = 0
            Utilities.logEvent(name: "Bikes available segmented control", parameters: ["Type": "Bikes"])
        case 1:
            type = 1
            Utilities.logEvent(name: "BikeStands available segmented control", parameters: ["Type": "BikeStands"])
        default:
            break
        }
        self.mapView.removeAnnotations(myRealStations)
        self.mapView.addAnnotations(myRealStations)
    }
    
    // MARK: - Fonctions
    
    func centerMap(on location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
    }
    
    // MARK: - View Cyclelife

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapView.addAnnotations(myRealStations)
        
        /*for myRealStation in myRealStations {
            addAnnotation(coordinate: myRealStation.coordinate)
        }*/
        
        if mySelectedStation != nil {
            centerMap(on: mySelectedStation!.coordinate)
        } else {
            centerMap(on: .init(latitude: 48.853590, longitude: 2.348808))
        }
        
        initUserLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        Utilities.logEvent(name: "MapViewController did appear")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let station = annotation as? Station else {
            NSLog("l'annotation n'est pas de type station")
            return nil
        }
        
        /*mapView.delegate = self*/
        
        let identifier = "pin"
        var view: MKAnnotationView
        /*if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        {
            dequeuedView.annotation = station
            view = dequeuedView
        } else {*/
            view = MKAnnotationView(annotation: station, reuseIdentifier: identifier)
        //}
        
        view.centerOffset = CGPoint(x: 0, y: -20)
        view.canShowCallout = true
        
        /*if myRealFavoriteStations.contains(station) == true {
            view.image = #imageLiteral(resourceName: "station_orange")
        } else {
            view.image = #imageLiteral(resourceName: "station_grise")
        }*/
        
        station.isFavorite ? (view.image = #imageLiteral(resourceName: "station_orange")) : (view.image = #imageLiteral(resourceName: "station_grise"))
        
        view.frame.size = CGSize(width: 36, height: 40)
        
        let myCGRect = CGRect(x: 0, y: 8, width: view.frame.size.width, height: view.frame.size.height/4)
        let myView = UILabel(frame: myCGRect)
        view.addSubview(myView)
        
        switch type {
        case 0:
            myView.text = String(station.availableBikes)
        case 1:
            myView.text = String(station.availableBikeStands)
        default:
            break
        }
        
        myView.font = UIFont.systemFont(ofSize: 13.0)
        myView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        myView.textAlignment = .center
        
        if station.isFavorite == false {
            let starButton = UIButton(type: .custom)
            starButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            starButton.setBackgroundImage(#imageLiteral(resourceName: "fleche_creuse"), for: .normal)
            view.rightCalloutAccessoryView = starButton
        } else {
            let starButton2 = UIButton(type: .custom)
            starButton2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            starButton2.setBackgroundImage(#imageLiteral(resourceName: "fleche_pleine"), for: .normal)
            view.rightCalloutAccessoryView = starButton2
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let station = view.annotation as? Station else {
            NSLog("La station n'est pas ok")
            return
        }
        
        NSLog("La station \(station.title ?? "") a été cliquée")
        
        if station.isFavorite == false {
            PersistanceHelper.addFavoriteStationId (value: station.stationId)
            station.isFavorite = true
        }  else {
            PersistanceHelper.removeFavoriteStationId(value: station.stationId)
            station.isFavorite = false
        }
        self.mapView.removeAnnotations(myRealStations)
        self.mapView.addAnnotations(myRealStations)
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
