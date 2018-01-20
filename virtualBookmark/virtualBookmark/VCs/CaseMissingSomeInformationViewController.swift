//
//  NoNbPagesViewController.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 21/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import UIKit
import MobileCoreServices
import SDWebImage

class CaseMissingSomeInformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var totalPagesTextField: UITextField!
    @IBOutlet weak var informationTextView: UITextView!
    @IBOutlet weak var authorsTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var progressActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var blurImageView: UIImageView!

    // MARK: - Variables globales
    
    var myBook: Book?
    
    // MARK: - IBActions
    
    @IBAction func validateButtonPressed(_ sender: UIButton) {
        
        UIButton.animate(withDuration: 0.1, animations: {sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)}, completion: { finish in
            UIButton.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            })
            if self.coverImageView.image != nil && self.totalPagesTextField.text != "" && self.authorsTextField.text != "" {
                self.performSegue(withIdentifier: "goBackToFirstVCWithData", sender: nil)
            } else {
                Utilities.presentAlert(titleMessage: "missingInfos.missingInfosTitle".translate, message: "missingInfos.missingInfosMessage".translate, titleAction: "missingInfos.missingInfosAction".translate, styleMessage: .alert, styleAction: .destructive, viewController: self, myCompletion: {success in
                })
            }
        })
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        UIButton.animate(withDuration: 0.1, animations: {sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)}, completion: { finish in
            UIButton.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            })
            self.performSegue(withIdentifier: "goBackToFirstVCWithoutData", sender: nil)
        })
    }
    
    @IBAction func coverButtonPressed(_ sender: UIButton) {
        
        Utilities.startIndicatorView(viewController: self, progressActivityIndicatorView: progressActivityIndicatorView, view: scrollView, blurImage: blurImageView)
        
        Utilities.useCamera(viewController: self)
    }
    
    @IBAction func editDidBegin () {
        scrollView.moveUpForKeyboard()
    }
    
    @IBAction func screenWasTaped(_ sender: Any) {
        
        // Resign first responder
        totalPagesTextField.resignFirstResponder()
        authorsTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        
        Utilities.borderColorTextFieldDisplay(totalPagesTextField: totalPagesTextField, authorsTextField: authorsTextField, titleTextField: titleTextField)
        
        scrollView.moveDownForKeyboard()
    }
    
     // MARK: - Fonctions
    
    // Fonction déclenchée quand on a pris une photo: recupère une photo via le pickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType == kUTTypeImage as String {
            
            // Récupération de l'image
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
                print("image not good")
                return
            }
            
            Utilities.stopIndicatorView(viewController: self, progressActivityIndicatorView: progressActivityIndicatorView, view: scrollView, blurImage: blurImageView)
            
            // Mise à jour de l'image
            coverImageView.image = image
            coverImageView.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            coverButton.isHidden = true
            
            if myBook != nil {
                let fileName = Utilities.saveImageToCaches(image: image)
                PersistanceHelper.updateBookCoverURL(book: myBook!, coverURL: fileName)
            }
        }
    }
    
    // Fonction déclenchée quand l'utilisateur clique sur le bouton cancel du pickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
        
        Utilities.stopIndicatorView(viewController: self, progressActivityIndicatorView: progressActivityIndicatorView, view: scrollView, blurImage: blurImageView)
    }
    
    // Fonctions réalisées lorsque l'utilisateur clique le bouton "return" du clavier normal
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        Utilities.borderColorTextFieldDisplay(totalPagesTextField: totalPagesTextField, authorsTextField: authorsTextField, titleTextField: titleTextField)
        scrollView.moveDownForKeyboard()
        return true
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleTextField.delegate = self
        self.authorsTextField.delegate = self
        self.totalPagesTextField.delegate = self
        
        // On masque les éléments du navigation controller
        navigationItem.hidesBackButton = true
        navigationItem.title = "missingInfos.addingInfos".translate
  
        
        // Gestion de la grosseur et apparence de l'encadré
        totalPagesTextField.layer.borderWidth = 3
        coverImageView.layer.borderWidth = 3
        titleTextField.layer.borderWidth = 3
        authorsTextField.layer.borderWidth = 3
        totalPagesTextField.layer.cornerRadius = 4.5
        coverImageView.layer.cornerRadius = 4.5
        titleTextField.layer.cornerRadius = 4.5
        authorsTextField.layer.cornerRadius = 4.5
        
        // Gestion du display et du contenu des éléments
        cancelButton.backgroundColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
        cancelButton.layer.cornerRadius = 4.5
        validateButton.backgroundColor = #colorLiteral(red: 0.4444844127, green: 0.8342097402, blue: 0.8048048615, alpha: 1)
        validateButton.layer.cornerRadius = 4.5
        informationTextView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        informationTextView.layer.borderWidth = 2
        informationTextView.layer.cornerRadius = 4.5
        
        if myBook != nil { // si l'instance myBook a été créée mais il manque des informations
            
            titleTextField.text = myBook!.title
            titleTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
            titleTextField.isUserInteractionEnabled = false
            
            if (myBook!.coverURL == "" || myBook!.coverURL == nil) && myBook!.totalNbPages.value == nil && myBook!.authors.count == 0 {
                print ("Tout est à renseigner")
            } else if (myBook!.coverURL == "" || myBook!.coverURL == nil) && myBook!.totalNbPages.value == nil {
                var authorString = ""
                for author in myBook!.authors {
                    authorString += author + ", "
                }
                let endIndex = authorString.index(authorString.endIndex, offsetBy: -2)
                authorsTextField.text = String(authorString[..<endIndex])
                authorsTextField.isUserInteractionEnabled = false
                authorsTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
                coverImageView.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
            } else if (myBook!.coverURL == "" || myBook!.coverURL == nil) && myBook!.authors.count == 0 {
                totalPagesTextField.text = String(myBook!.totalNbPages.value!)
                totalPagesTextField.isUserInteractionEnabled = false
                totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                authorsTextField.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
                coverImageView.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
            } else if myBook!.totalNbPages.value == nil && myBook!.authors.count == 0 {
                coverImageView.sd_setImage(with: URL(string:myBook!.coverURL!))
                coverButton.isHidden = true
                coverImageView.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                authorsTextField.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
                totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
            } else if myBook!.coverURL == "" || myBook!.coverURL == nil {
                var authorString = ""
                for author in myBook!.authors {
                    authorString += author + ", "
                }
                let endIndex = authorString.index(authorString.endIndex, offsetBy: -2)
                authorsTextField.text = String(authorString[..<endIndex])
                authorsTextField.isUserInteractionEnabled = false
                totalPagesTextField.text = String(myBook!.totalNbPages.value!)
                totalPagesTextField.isUserInteractionEnabled = false
                authorsTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                coverImageView.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
            } else if myBook!.totalNbPages.value == nil {
                var authorString = ""
                for author in myBook!.authors {
                    authorString += author + ", "
                }
                let endIndex = authorString.index(authorString.endIndex, offsetBy: -2)
                authorsTextField.text = String(authorString[..<endIndex])
                authorsTextField.isUserInteractionEnabled = false
                coverImageView.sd_setImage(with: URL(string:myBook!.coverURL!))
                coverButton.isHidden = true
                authorsTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                coverImageView.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
            } else {
                totalPagesTextField.text = String(describing: myBook!.totalNbPages.value!)
                totalPagesTextField.isUserInteractionEnabled = false
                coverImageView.sd_setImage(with: URL(string:myBook!.coverURL!))
                coverButton.isHidden = true
                totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                coverImageView.layer.borderColor = #colorLiteral(red: 0.3843137255, green: 0.8039215686, blue: 0.7607843137, alpha: 1)
                authorsTextField.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
            }
            
        } else { // si l'instance myBook n'a pas été créée car la référence n'a pas été trouvée
            
            totalPagesTextField.layer.borderColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.4, alpha: 1)
            coverImageView.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
            titleTextField.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
            authorsTextField.layer.borderColor = #colorLiteral(red: 0.9517953992, green: 0.4906297922, blue: 0.4742498398, alpha: 1)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        informationTextView.text = "missingInfos.explanationText".translate
        titleTextField.placeholder = "missingInfos.formPlaceholderTitle".translate
        authorsTextField.placeholder = "missingInfos.formPlaceholderAuthors".translate
        totalPagesTextField.placeholder = "missingInfos.formPlaceholderPage".translate
        validateButton.setTitle("missingInfos.formValidateButtonText".translate, for: .normal)
        cancelButton.setTitle("missingInfos.formCancelButtonText".translate, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
