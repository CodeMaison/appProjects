//
//  Extensions.swift
//  troiswresto
//
//  Created by etudiant21 on 08/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation
import UIKit

// MARK:-- Extension text view

/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = true
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
        return true
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}


// MARK:-- Extension scroll view

extension UIScrollView {
    
    func moveUpForKeyboard() {
        let contentInsets =  UIEdgeInsetsMake(0.0, 0.0, 260, 0.0)
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
    
    func moveDownForKeyboard() {
        let contentInsets =  UIEdgeInsets.zero
        self.contentInset = contentInsets
        self.scrollIndicatorInsets = contentInsets
    }
}

// MARK:-- Extension localisation langues

extension String {
    func translate (comment: String = "") -> String {
        let resultTranslation = NSLocalizedString(self, comment: comment)
        return resultTranslation
    }
    var translate: String {
        let resultTranslation = NSLocalizedString(self, comment: "")
        return resultTranslation
    }
}

/*1) Créer un fichier nommé "Localizable.strings"
2) Localiser ce fichier
3) Dans les paramètres du projet, ajouter la langue French
4) Décocher Main.storyboard et launchscreen
5) Mais garder Localizable.strings
6) Utiliser la syntaxe
welcomeLabel.text = NSLocalizedString("Welcome", comment: "le message d'accueil")

7) Compléter les traductions dans la version French du fichier Localizable.strings
"Welcome" = "Bienvenue";*/
