//
//  Utilities.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 02/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class Utilities {
    
    // Fonction de présentation d'alerte pour l'utilisateur
    static func presentAlert (titleMessage: String, message: String, titleAction: String, styleMessage: UIAlertControllerStyle, styleAction: UIAlertActionStyle, viewController: UIViewController, myCompletion: @escaping (Bool?) -> Void) {
        
        let alert = UIAlertController(title: titleMessage, message: message, preferredStyle: styleMessage)
        alert.addAction(UIAlertAction(title: titleAction, style: styleAction, handler: {success in
            myCompletion(true)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // Fonction pour sauvegarder localement la photo de la page de couverture qui a été prise par l'utilisateur si non disponible dans API Google
    static func saveImageToCaches(image: UIImage) -> String? {
        var documentsUrl: URL {
            return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        }
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let dateString = formatter.string(from: now)
        let fileName = dateString.appending(".jpg")
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileName
        }
        print("Error saving image")
        return nil
    }
    
    // Fonction pour récupérer la photo de la page de couverture sauvegardée localement
    static func getImageFromCaches(fileName: String) -> UIImage? {
        var documentsUrl: URL {
            return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        }
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    // Fonction pour supprimer une photo de la page de couverture sauvegardée localement
    static func deleteImageFromCaches(fileName: String) {
        var documentsUrl: URL {
            return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        }
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting image : \(error)")
        }
    }
    
    // Fonction pour utiliser l'appareil photo pour prendre en photo la couverture du livre
    static func useCamera(viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            viewController.present(imagePicker, animated: true,
                                   completion: nil)
        }
    }
    
    // Fonction qui update affichage message pas de livre
    static func updateDisplayIfNoBook (books: [Book], noBookLabel: UILabel, view: UIScrollView) {
        if books.count == 0 {
            noBookLabel.isHidden = false
            view.isHidden = true
        } else {
            noBookLabel.isHidden = true
            view.isHidden = false
        }
    }
    
    // Fonction qui met à jour l'image de couverture sur la page d'historique des lectures
    static func updateCoverImageHistorical (indexPathRow: Int, books: [Book], cell: CustomCellHistorical) {
        if books[indexPathRow].coverURL?.contains("http") == true && books[indexPathRow].isFavorite == false {
            cell.coverImageView.sd_setImage(with: URL(string:books[indexPathRow].coverURL!))
            cell.favoriteView.isHidden = true
            cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-add"), for: .normal)
        } else if books[indexPathRow].coverURL?.contains("http") == true && books[indexPathRow].isFavorite == true {
            cell.coverImageView.sd_setImage(with: URL(string:books[indexPathRow].coverURL!))
            cell.favoriteView.isHidden = false
            cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-remove"), for: .normal)
        } else if books[indexPathRow].coverURL?.contains("http") == false && books[indexPathRow].isFavorite == false {
            cell.coverImageView.image = Utilities.getImageFromCaches(fileName: books[indexPathRow].coverURL!)
            cell.favoriteView.isHidden = true
            cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-add"), for: .normal)
        } else {
            cell.coverImageView.image = Utilities.getImageFromCaches(fileName: books[indexPathRow].coverURL!)
            cell.favoriteView.isHidden = false
            cell.favoriteOptionsButton.setBackgroundImage(#imageLiteral(resourceName: "icons8-christmas-star-filled-100-remove"), for: .normal)
        }
        cell.favoriteView.layer.cornerRadius = 2
    }
    
    // Démarrage de l'indicator view
    static func startIndicatorView (viewController: UIViewController, progressActivityIndicatorView: UIActivityIndicatorView, view: UIView, blurImage: UIImageView) {
        progressActivityIndicatorView.isHidden = false
        blurImage.isHidden = false
        view.isHidden = true
        progressActivityIndicatorView.startAnimating()
    }
    
    // Arrêt de l'indicator view
    static func stopIndicatorView (viewController: UIViewController, progressActivityIndicatorView: UIActivityIndicatorView, view: UIView, blurImage: UIImageView) {
        view.isHidden = false
        progressActivityIndicatorView.stopAnimating()
        progressActivityIndicatorView.hidesWhenStopped = true
        blurImage.isHidden = true
    }
    
    // Gestion de la couleur des encadrés
    static func borderColorTextFieldDisplay(totalPagesTextField: UITextField,authorsTextField: UITextField,titleTextField: UITextField) {
        if totalPagesTextField.text != "" && authorsTextField.text != "" && titleTextField.text != "" {
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            titleTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
        } else if totalPagesTextField.text != "" && authorsTextField.text != "" {
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            titleTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
        } else if authorsTextField.text != "" && titleTextField.text != "" {
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            titleTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
        } else if totalPagesTextField.text != "" && titleTextField.text != "" {
            titleTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
        } else if totalPagesTextField.text != "" {
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            titleTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
        } else if authorsTextField.text != "" {
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
            titleTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
        } else if titleTextField.text != "" {
            titleTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
        } else {
            titleTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
        }
    }    
    
}
