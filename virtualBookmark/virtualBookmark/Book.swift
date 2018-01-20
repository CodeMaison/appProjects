//
//  Book.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 30/11/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    
    @objc dynamic var idBook = ""
    @objc dynamic var title = ""
    var authors = List<String>()
    @objc dynamic var coverURL: String?
    var totalNbPages = RealmOptional<Int>()
    @objc dynamic var dateOfStartReading = ""
    @objc dynamic var dateOfEndReading: String?
    @objc private dynamic var privateStatus: Int = Status.EnCours.rawValue
    @objc dynamic var isFavorite = false
    var status: Status {
        get { return Status(rawValue: privateStatus)! }
        set { privateStatus = newValue.rawValue }
    }
    var bookmarkValue = RealmOptional<Int>()
    
    var progressReading: Double {
        if let bookmarkNumber = bookmarkValue.value
        , let totalNbPages = totalNbPages.value {
            if bookmarkNumber <= totalNbPages {
                let purcentage = Double(bookmarkNumber) / Double(totalNbPages) * 100
                return purcentage
            } else {
                return 0.0
            }
        } else {
            return 0.0
        }
    }
    
    var dateOfStartReadingDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let mydateOfStartReadingDate = formatter.date(from: dateOfStartReading) {
            return mydateOfStartReadingDate
        } else {
            print ("La conversion de la date de début a échoué")
            return nil
        }
    }
    
    var dateOfEndReadingDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let dateString = dateOfEndReading
            , let mydateOfEndReadingDate = formatter.date(from: dateString) {
                return mydateOfEndReadingDate
        } else {
            print ("La conversion de la date de fin a échoué")
            return nil
        }
    }
    
}
