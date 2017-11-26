//
//  JCDecauxHelper.swift
//  myVelib
//
//  Created by etudiant21 on 24/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class JCDecauxHelper {
    
    static func getContracts (myCompletion: @escaping ([Contract]) -> Void) {
        
        var myContracts = [Contract] ()
        
        Alamofire.request("https://api.jcdecaux.com/vls/v1/contracts?apiKey=\(Parameters.apiKey)").response { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Data: \(String(describing: response.data))")         // response data
            print("Error: \(String(describing: response.error))")       // response error
            
            if let data = response.data
                , let myJsons = JSON(data: data).array {
                for myJson in myJsons {
                    if let name = myJson["name"].string
                        , let commercialName = myJson["commercial_name"].string
                        , let countryCode = myJson["country_code"].string {
                        
                        let myContract = Contract(name: name, commercialName: commercialName, countryCode: countryCode)
                        
                        myContracts.append(myContract)
                        
                    } else {
                        print ("Il y a un pb dans le parsing du fichier JSON contrat")
                    }
                }
                myCompletion(myContracts)
            } else {
                myCompletion([Contract]())
            }
        }
    }
    
    
    static func getStations(myCompletion: @escaping ([Station]) -> Void) {
        
        var myStations = [Station] ()
        
        Alamofire.request("https://api.jcdecaux.com/vls/v1/stations?apiKey=\(Parameters.apiKey)&contract=\(Parameters.contract)").response { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Data: \(String(describing: response.data))")         // response data
            print("Error: \(String(describing: response.error))")       // response error
            
            if let data = response.data
                , let myJsons = JSON(data: data).array {
                
                let myQueue = DispatchQueue(label: "myQueue")
                
                myQueue.async {
                    
                    for myJson in myJsons {
                        if let idStation = myJson["number"].int
                            , let title = myJson["name"].string
                            , let address = myJson["address"].string
                            , let positionLat = myJson["position"]["lat"].double
                            , let positionLng = myJson["position"]["lng"].double
                            , let status = myJson["status"].string
                            , let contract = myJson["contract_name"].string
                            , let availableBikeStands = myJson["available_bike_stands"].int
                            , let availableBikes = myJson["available_bikes"].int
                            , myJson["status"].string == "OPEN" {
                            
                            let coordinate = CLLocationCoordinate2D(latitude: positionLat, longitude: positionLng)
                            
                            let isOpened = (status == "OPEN")
                            
                            /*var isOpened = true
                             if status == "OPEN" {
                             isOpened = true
                             } else {
                             isOpened = false
                             }*/
                            
                            let myStation = Station(stationId: idStation, title: title, address: address, coordinate: coordinate, isOpened: isOpened, contract: contract, availableBikeStands: availableBikeStands, availableBikes: availableBikes)
                            
                            myStations.append(myStation)
                            
                        } else {
                        }
                    }
                    DispatchQueue.main.async {
                        myCompletion(myStations)
                    }
                }
            } else {
                myCompletion([Station]())
            }
        }
    }
}
