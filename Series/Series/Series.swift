//
//  Series.swift
//  Series
//
//  Created by etudiant21 on 12/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation

import UIKit

struct Serie {
    var image: UIImage
    var title: String
    var categorie: Category
    var description: String
}

enum Category {
    case Horror, Drama, Comedy, Fantasy
    var textToDisplay: String {
        switch self {
        case .Horror:
            return "Horreur"
        case .Drama:
            return "Drame"
        case .Comedy:
            return "Comédie"
        case .Fantasy:
            return "Fantaisie"
        }
    }
}

