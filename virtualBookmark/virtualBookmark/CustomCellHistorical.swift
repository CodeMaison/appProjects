//
//  CustomCellHistorical.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 15/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import Foundation
import UIKit

protocol CustomCellHistoricalDelegate: class {
    func favoriteButtonPressed (_ indexPath: IndexPath, _ cell: CustomCellHistorical)
    func deleteButtonPressed (_ indexPath: IndexPath, _ cell: CustomCellHistorical)
}

class CustomCellHistorical: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var favoriteOptionsButton: UIButton!
    @IBOutlet weak var deleteOptionsButton: UIButton!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var starFavoriteImageView: UIImageView!
    @IBOutlet weak var favoriteView: UIView!
    
    var indexPath: IndexPath!
    
    weak var delegate: CustomCellHistoricalDelegate?
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1, animations: {sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)}, completion: { finish in
            UIButton.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            })
            self.delegate?.favoriteButtonPressed(self.indexPath, self)
        })
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1, animations: {sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)}, completion: { finish in
            UIButton.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            })
            self.delegate?.deleteButtonPressed(self.indexPath, self)
        })
    }
}
