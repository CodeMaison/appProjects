//
//  GoogleHelper.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 30/11/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GoogleHelper {
    
    // Fonction de récupération des données du livre
    
    static func requestBookData (ISBN: String, myCompletion: @escaping (Book?) -> Void) {
        
        Alamofire.request("https://www.googleapis.com/books/v1/volumes?q=isbn:\(ISBN)&key=\(Parameters.apiKey)").response { response in
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Data: \(String(describing: response.data))")         // response data
            print("Error: \(String(describing: response.error))")       // response error
            
            if let data = response.data
                , let myJson = try? JSON(data: data)
                , myJson != JSON.null {
                guard myJson["totalItems"].int != 0  else {
                    print ("Aucun livre n'a été trouvé")
                    myCompletion(nil)
                    return
                }
                for item in myJson["items"].arrayValue {
                    if let idBook = item["id"].string
                        , let title = item["volumeInfo"]["title"].string {
                        
                        var authors = [String]()
                        for author in item["volumeInfo"]["authors"].arrayValue {
                            authors.append(String(describing: author))
                        }
                        
                        let totalNbPages = item["volumeInfo"]["pageCount"].int
                        
                        let coverURL = item["volumeInfo"]["imageLinks"]["thumbnail"].string
                        
                        let dateOfStartReadingString = Date().returnCurrentDateString()
                        
                        let myBook = Book(value: ["idBook": idBook+dateOfStartReadingString, "title": title, "authors": authors, "totalNbPages": totalNbPages as Any, "coverURL": coverURL as Any, "dateOfStartReading": dateOfStartReadingString, "status": Status.EnCours, "isFavorite": false])
                        
                        myCompletion(myBook)
                        
                    } else {
                        print ("Il n'y a pas les données nécessaires pour créer l'instance myBook")
                        myCompletion(nil)
                    }
                }
            } else {
                print ("Le JSON est vide")
                myCompletion(nil)
            }
        }
    }
}
