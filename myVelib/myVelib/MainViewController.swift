//
//  MainViewController.swift
//  myVelib
//
//  Created by etudiant21 on 25/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var myTableViewMain: UITableView!
    
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var logoButton: UIButton!
    
    // MARK: - Variables globales
    
    var myRealStations = [Station] ()
    
    var myRealFavoriteStations = [Station] ()
    
    var myFavoriteStationsIds = [Int] ()
    
    var screenType = ScreenType.home
    
    let locationManager = CLLocationManager()
    
    // MARK: - Actions
    
    
    @IBAction func changeCityButtonPressed(_ sender: UIButton) {
        makeContractControllerAppear()
        Utilities.logEvent(name: "User changed the city")
    }
    
    @IBAction func tutorielButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    // MARK: - Fonctions
    
    func makeContractControllerAppear () {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contractViewController") as? ContractViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func updateStations (userLocation: CLLocation?) {
        
        JCDecauxHelper.getStations(myCompletion: { receivedStations in
            
            self.myRealStations = receivedStations
            
            /* for myRealFavoriteStation in myRealFavoriteStations {
             myRealFavoriteStation.isFavorite = true*/
            
            switch self.screenType {
                
            case .home:
                self.myRealFavoriteStations = self.myRealStations
                    .filter {self.myFavoriteStationsIds.contains($0.stationId)}
                
                self.myRealFavoriteStations.forEach{$0.isFavorite = true}
                
            case .geoloc:
                self.myRealFavoriteStations = self.myRealStations.filter {userLocation?.distance(from: CLLocation(latitude: $0.coordinate.latitude, longitude:$0.coordinate.longitude)) ?? 4000 < 500 }
                
            }
            
            print("We have now \(self.myRealFavoriteStations.count) stations")
            
            
            if self.myRealFavoriteStations.count == 0 {
                self.myTextView.isHidden = false
                self.myTableViewMain.isHidden = true
            } else {
                self.myTextView.isHidden = true
                self.myTableViewMain.isHidden = false
            }
            self.myTableViewMain.reloadData()
            NSLog ("La requête est terminée")
        })
        
    }
    
    func initUserLocation() {
        
        locationManager.delegate = self
        
        // définition de la précision
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        // demarrage de la loc
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard manager.location != nil else {
            print("no location or stations empty")
            return
        }
        
        print("my location is \(manager.location!)")
        
        locationManager.stopUpdatingLocation()
        
        // mettre à jour l'affichage des stations

        let userLocation = manager.location ?? nil
        
        updateStations(userLocation: userLocation)
        
    }
    
    // MARK: - View Cyclelife
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap" {
            if let destination = segue.destination as? MapViewController {
                if let indexPath = myTableViewMain.indexPathForSelectedRow {
                    destination.myRealStations = myRealStations
                    destination.myRealFavoriteStations = myRealFavoriteStations
                    destination.mySelectedStation = myRealFavoriteStations [indexPath.row]
                } else {
                    destination.myRealStations = myRealStations
                    destination.myRealFavoriteStations = myRealFavoriteStations
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog ("La vue a chargé")
        self.myTableViewMain.reloadData()
        
        switch screenType {
        case .home:
            logoButton.setBackgroundImage(#imageLiteral(resourceName: "homex2"), for: .normal)
        case .geoloc:
            logoButton.setBackgroundImage(#imageLiteral(resourceName: "geolocx2"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        print ("contrat: \(Parameters.contract)")
        
        myFavoriteStationsIds = PersistanceHelper.getFavoriteStationsId()
        
        switch screenType {
        case .home:
            updateStations(userLocation: nil)
        case .geoloc:
            initUserLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.string(forKey: "myVelibVilleSelectionnee") == nil {
            makeContractControllerAppear()
        }
        
        Utilities.logEvent(name: "MainViewController did appear")
        NSLog ("La vue est apparue")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("In tableview count=\(myRealFavoriteStations.count)")
        return myRealFavoriteStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        // La ligne selectionnée est indexPath.row
        
        /*if let title = myRealFavoriteStations[indexPath.row].title {
         if let index = title.endIndex(of: "- ") {
         cell.nameStationLabel.text = String(title.suffix(from: index))
         } else {
         cell.nameStationLabel.text = title
         }
         }*/
        
        cell.nameStationLabel.text = myRealFavoriteStations[indexPath.row].title
        cell.availableBikesLabel.text = String(myRealFavoriteStations[indexPath.row].availableBikes)
        cell.availableBikeStandsLabel.text = String(myRealFavoriteStations[indexPath.row].availableBikeStands)
        
        // NSLog("\(myRealFavoriteStations[indexPath.row].title)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("la ligne \(indexPath.row) a été selectionnée")
        
        performSegue(withIdentifier: "toMap", sender: nil)
        
        Utilities.logEvent(name: "User selected a favorite station", parameters: ["favoriteStations": myRealFavoriteStations[indexPath.row].stationId ])
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}

extension String {
    
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    func transformMyTitle (title: String) -> String {
        var titleTransformed = ""
        if title.contains("- ") {
            if let index = title.endIndex(of: "- ") {
                titleTransformed = String(title.suffix(from: index))
            }
            return titleTransformed
        } else if title.contains("-") {
            if let index = title.endIndex(of: "-") {
                titleTransformed = String(title.suffix(from: index))
            }
            return titleTransformed
        } else if title.contains("_") {
            if let index = title.endIndex(of: "_") {
                titleTransformed = String(title.suffix(from: index))
            }
            return titleTransformed
        } else {
            return title
        }
    }
    
    func replaceElements (title: String) -> String {
        let titleTransformed = transformMyTitle(title: title)
        let titleDoubleTransformed = titleTransformed.replacingOccurrences(of: "_", with: " ")
        return titleDoubleTransformed
    }
}
