//
//  NewBookViewController.swift
//  virtualBookmark
//
//  Created by Anne Laure Civeyrac on 01/12/2017.
//  Copyright © 2017 Anne Laure Civeyrac. All rights reserved.
//

import UIKit
import AVFoundation

class NewBookViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - IBOutlets
    
    // MARK: - Variables globales
    
    var session: AVCaptureSession!
    
    // MARK: - IBActions
    
    // MARK: - Fonctions
    
    // Fonction pour traiter le cas où le scanning n'est pas possible
    func scanningNotPossible() {
        // Let the user know that scanning isn't possible with the current device.
        Utilities.presentAlert(titleMessage: "newBook.erreurScanningTitle".translate, message: "newBook.erreurScanningMessage".translate, titleAction: "newBook.erreurScanningAction".translate, styleMessage: .alert, styleAction: .default, viewController: self, myCompletion: {success in
            self.navigationController?.popViewController(animated: true)
        })
        session = nil
    }
    
    // Fonction pour gérer ce que l'on affiche après avoir scanné le code barre en fonction du résultat
    func displayAfterScanning(book: Book?, blurEffectView: UIVisualEffectView,progressActivityIndicatorView: UIActivityIndicatorView) {
        if book == nil { // si l'instance myBook n'a pas été créée car la référence n'a pas été trouvée
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MissingInfo") as? CaseMissingSomeInformationViewController {
                if let navigator = self.navigationController {
                    viewController.hidesBottomBarWhenPushed = true
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        } else if book?.authors.count == 0 || book?.coverURL == "" || book?.coverURL == nil || book?.totalNbPages == nil { // si l'instance myBook a été créée mais il manque des informations
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MissingInfo") as? CaseMissingSomeInformationViewController {
                if let navigator = self.navigationController {
                    viewController.hidesBottomBarWhenPushed = true
                    PersistanceHelper.setBook(book: book!)
                    viewController.myBook = book!
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        } else { // si l'instance myBook a été créée et il ne manque pas d'information
            PersistanceHelper.setBook(book: book!)
            // On retourne sur le VC des lectures
            self.navigationController?.popViewController(animated: true)
        }
        blurEffectView.removeFromSuperview()
        progressActivityIndicatorView.removeFromSuperview()
    }
    
    // Fonction pour indiquer que le barcode a été détecté
    func barcodeDetected(code: String) {
        
        // Let the user know we've found something
        let alert = UIAlertController(title: "newBook.okScanningTitle".translate, message: "newBook.okScanningMessage".translate, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "newBook.okScanningAction".translate, style: .destructive, handler: { action in
            
            // Ajout d'un effet blur sur la vue
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            
            // Ajout d'une indicator view
            let progressActivityIndicatorView = UIActivityIndicatorView()
            progressActivityIndicatorView.center = self.view.center
            progressActivityIndicatorView.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            let transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            progressActivityIndicatorView.transform = transform
            self.view.addSubview(progressActivityIndicatorView)
            
            // Démarrage de l'indicator view
            progressActivityIndicatorView.startAnimating()
            
            // Remove the spaces
            let trimmedCode = code.trimmingCharacters(in: CharacterSet.whitespaces)
            
            // EAN or UPC?: check for added "0" at beginning of code
            let trimmedCodeString = "\(trimmedCode)"
            var trimmedCodeNoZero: String
            
            if trimmedCodeString.hasPrefix("0") && trimmedCodeString.count > 1 {
                trimmedCodeNoZero = String(trimmedCodeString.dropFirst())
                
                // Send the doctored UPC to GoogleHelper
                GoogleHelper.requestBookData(ISBN: trimmedCodeNoZero, myCompletion: {book in
                    self.displayAfterScanning(book: book, blurEffectView: blurEffectView, progressActivityIndicatorView: progressActivityIndicatorView)
                })
                
            } else {
                
                // Send the doctored EAN to GoogleHelper
                GoogleHelper.requestBookData(ISBN: trimmedCodeString, myCompletion: {book in
                    self.displayAfterScanning(book: book, blurEffectView: blurEffectView, progressActivityIndicatorView: progressActivityIndicatorView)
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Fonction pour gérer le résultat de la capture
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Get the first object from the metadataObjects array
        if let barcodeData = metadataObjects.first {
            // Turn it into machine readable code
            let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject
            if let readableCode = barcodeReadable {
                // Send the barcode as a string to barcodeDetected()
                barcodeDetected(code: readableCode.stringValue ?? "")
            }
            
            // Vibrate the device to give the user some feedback
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Avoid a very buzzy device
            session.stopRunning()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var previewLayer: AVCaptureVideoPreviewLayer!
        
        // Create a session object
        session = AVCaptureSession()
        
        // Set the captureDevice
        if let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            
            // Create input object
            let videoInput: AVCaptureDeviceInput?
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            // Add input to the session
            if videoInput != nil {
                if (session.canAddInput(videoInput!)) {
                    session.addInput(videoInput!)
                } else {
                    scanningNotPossible()
                }
            } else {
                print ("La création de l'input object n'a pas pu être faite")
            }
        } else {
            print ("Le set de la capture device n'a pas pu être fait")
        }
        
        // Create output object
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Add output to the session
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            // Send captured data to the delegate object via a serial queue
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Set barcode types for which to scan
            metadataOutput.metadataObjectTypes =
                metadataOutput.availableMetadataObjectTypes
            
        } else {
            scanningNotPossible()
        }
        
        // Add previewLayer and have it show the video data
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Begin the capture session
        session.startRunning()
        
        // Display scanning rectangle
        let width = 250
        let height = 100
        let xPos = (CGFloat(self.view.frame.size.width) / CGFloat(2)) - (CGFloat(width) / CGFloat(2))
        let yPos = (CGFloat(self.view.frame.size.height) / CGFloat(2)) - (CGFloat(height) / CGFloat(2))
        let barcodeArea = CGRect(x: Int(xPos), y: Int(yPos), width: width, height: height)
        let barcodeAreaView = UIView()
        barcodeAreaView.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        barcodeAreaView.layer.borderWidth = 4
        barcodeAreaView.frame = barcodeArea
        view.addSubview(barcodeAreaView)
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: barcodeArea)
        
        // Display explanation text for scanning
        let explanationTextLabel = UILabel()
        explanationTextLabel.text = "newBook.barcodePosition".translate
        explanationTextLabel.textAlignment = .center
        explanationTextLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        explanationTextLabel.frame = CGRect(x: xPos, y: yPos - 22, width: 250, height: 20)
        view.addSubview(explanationTextLabel)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if (session?.isRunning == false) {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if (session?.isRunning == true) {
            session.stopRunning()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
