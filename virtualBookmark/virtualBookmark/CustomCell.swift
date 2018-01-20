//
//  CustomCell.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 01/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import Foundation
import UIKit
import UICircularProgressRing

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var bookmarkTextField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var progressView: UICircularProgressRingView!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
}
