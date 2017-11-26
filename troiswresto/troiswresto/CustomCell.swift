//
//  CustomCell.swift
//  troiswresto
//
//  Created by etudiant21 on 08/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceCategoryLabel: UILabel!
    @IBOutlet weak var averageGradeLabel : UILabel!
}

class CustomCellDeux: UITableViewCell {
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
}
