//
//  Model.swift
//  touchDemo
//
//  Created by Anne Laure Civeyrac on 16/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation

import UIKit

struct Brush {
    var size: Float
    var color: UIColor
    var type: Int
}

enum FontAwesomeIcons: String {
    case delete = "\u{f12d}"
    case back = "\u{f04a}"
}
