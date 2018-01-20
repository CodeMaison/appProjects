//
//  Extensions.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 14/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import Foundation
import UIKit


extension Double {
    
    // Fonction pour enlever les décimales d'un nombre de type Double et le tranformer en String
    func setDoubleWithZeroDetail () -> String {
        return String(format: "%.0f", self)
    }
    
}

extension UIScrollView {
    
    // Fonction qui permet de faire remonter la table view si le clavier en masque une partie
    func moveUpForKeyboard() {
        let contentInsets =  UIEdgeInsetsMake(0.0, 0.0, 260, 0.0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
    // Fonction qui permet de faire redescendre la table view après la disparition du clavier
    func moveDownForKeyboard() {
        let contentInsets =  UIEdgeInsets.zero
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
}

extension Date {
    
    // Fonction qui permet de calculer le premier jour du mois en cours
    func startOfCurrentMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    // Fonction qui permet de calculer le premier jour du mois dernier
    func startOfLastMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: startOfCurrentMonth())!
    }
    
    // Fonction qui permet de calculer le premier jour de l'année en cours
    func startOfCurrentYear() -> Date {
        let components = Calendar.current.dateComponents([.year], from: self)
        return Calendar.current.date(from: components)!
    }
    
    // Fonction qui retourne la date et heure actuelle au format String
    func returnCurrentDateString () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let dateString = formatter.string(from: self)
        return dateString
    }
    
}

extension String {
    
    // Localisation langue textes
    var translate: String {
        let resultTranslation = NSLocalizedString(self, comment: "")
        return resultTranslation
    }
}
