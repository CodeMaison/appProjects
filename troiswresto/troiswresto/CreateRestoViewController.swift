//
//  ViewController.swift
//  troiswresto
//
//  Created by etudiant21 on 06/11/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices

class CreateRestoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceCategorySlider: UISlider!
    @IBOutlet weak var priceCategoryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cameraButtonPressed: UIButton!
    
    var myRestos = [Resto] ()
    var myKeys = [String] ()
    var realAddress: String!
    var coordinate: CLLocationCoordinate2D!
    

    @IBAction func createRestoButtonPressed(_ sender: UIButton) {
        validateButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        createResto()
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "Choisissez", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Appareil photo", style: .default, handler: { alert in
            self.useCamera()
        }))
            
        alertController.addAction(UIAlertAction(title: "Bibliothèque de photos", style: .default, handler: { alert in
            self.useCameraRoll()
         }))
        
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func screenWasTaped(_ sender: Any) {
        nameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        scrollView.moveDownForKeyboard()
    }
    
    @IBAction func editDidBegin () {
        scrollView.moveUpForKeyboard()
    }
    
    @IBAction func priceSliderValueChanged(_ sender: UISlider) {
        if priceCategorySlider.value == 0 || priceCategorySlider.value < 0.5 {
            priceCategoryLabel.text = "€"
        } else if priceCategorySlider.value == 1 || (priceCategorySlider.value > 0.5 && priceCategorySlider.value < 1.5) {
            priceCategoryLabel.text  = "€€"
        } else {
            priceCategoryLabel.text  = "€€€"
        }
    }
    
    
    func createResto () {
        
        let name = nameTextField.text ?? ""
        let address = addressLabel.text ?? ""
        let description = descriptionTextView.text ?? ""
        let coordinate = CLLocationCoordinate2D.init(latitude: self.coordinate.latitude , longitude: self.coordinate.longitude)
        let priceCategory = priceCategoryLabel.text ?? ""
        
        let image = imageImageView.image ?? nil
        
        if name != "" && address != "" && description != "" && priceCategory != "" {
            
            FirebaseHelper.createResto(title: name, coordinate: coordinate, address: address, description: description, picture: image, price: priceCategory, myCompletion: {error, myKey in
                if error != nil {
                    print ("Voici mon erreur: \(error!)")
                } else {
                    print ("Ca c'est ma clef: \(myKey!)")
                    self.myKeys.append(myKey!)
                    print (self.myKeys)
                    presentMessage(title1: "FELICITATIONS", message: "Votre restaurant a été ajouté!", title2: "OK", controller: self, myCompletion: {success in
                        self.performSegue(withIdentifier: "toHome", sender: nil)
                    })
                }
                self.validateButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            })
            
        } else {
            
            presentMessage(title1: "STOP", message: "Merci de renseigner tous les champs obligatoires pour continuer!", title2: "OK", controller: self, myCompletion: {success in
                self.validateButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            })
        }
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification){
        descriptionTextView.isScrollEnabled = true
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.scrollRangeToVisible(descriptionTextView.selectedRange)
        scrollView.moveUpForKeyboard()
    }
    
    /*func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView, text: String) {
        if textView.text.isEmpty {
            textView.text = text
            textView.textColor = UIColor.lightGray
        }
    }*/
    
    func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true,
                         completion: nil)
            //  newMedia = true
        }
    }
    
    
    // récupère une image dans le cameraRoll (bibliothèque)
    func useCameraRoll() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true,
                         completion: nil)
            // newMedia = false
        }
    }
    
    // Cette fonction est déclenchée quand on a pris une photo
    // recupère une photo via le pickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType == kUTTypeImage as String {
            
            // on récupère ici l'image
            guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
                print("image not good")
                return
            }
            
            // mettre à jour l'image sur la vue
            imageImageView.image = image
            cameraButtonPressed.layer.position.x = cameraButtonPressed.layer.position.x + (cameraButtonPressed.layer.position.x / 1.2)
            cameraButtonPressed.layer.position.y = cameraButtonPressed.layer.position.y - (cameraButtonPressed.layer.position.y / 2)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // FirebaseHelper.testWriteFirebase()
        // FirebaseHelper.testReadObserverFirebase()
        // FirebaseHelper.testWriteFirebaseWithCompletionBlock()
        
        validateButton.layer.borderWidth = 2
        validateButton.layer.borderColor = #colorLiteral(red: 0, green: 1, blue: 0.7932096912, alpha: 1)
        validateButton.layer.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.7932096912, alpha: 1)
        validateButton.layer.cornerRadius = validateButton.frame.width/15
        
        addressLabel.text = realAddress
        nameTextField.text = ""
        priceCategoryLabel.text = "€€"
        print (coordinate)
     
        self.descriptionTextView.placeholder = "Indiquez une description"
        
        /*textViewDidBeginEditing(descriptionTextView)
        textViewDidEndEditing(descriptionTextView, text: "Indiquer une description")*/
        
        /*for _ in 0...2 {
            FirebaseHelper.createResto(name: "Burger restaurant", coordinate: CLLocationCoordinate2D.init(latitude: 48.35, longitude: 3.56), address: "18 rue des bois", description: "bla bla bla bla bla bla bla", picture: nil, myCompletion: {error, myKey in
                if error != nil {
                    print ("Voici mon erreur: \(error!)")
                } else {
                    print ("Ca c'est ma clef: \(myKey!)")
                    self.myKeys.append(myKey!)
                    print (self.myKeys)
                }
            })
        }*/

        /*FirebaseHelper.getResto(myKey: myKey, myCompletion: { result in
            self.myResto = result
            print ("Voici mon resto sur le view controller: \(self.myResto.name), \(self.myResto.coordinate), \(self.myResto.address)")
        })*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

