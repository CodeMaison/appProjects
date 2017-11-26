//
//  ViewController.swift
//  touchDemo
//
//  Created by etudiant21 on 16/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, ColorPickerDelegate {

    @IBOutlet weak var beganFiguresLabel: UILabel!
    @IBOutlet weak var movedFiguresLabel: UILabel!
    @IBOutlet weak var endFiguresLabel: UILabel!
    @IBOutlet weak var sketchView: UIView!
    @IBOutlet weak var pickColorButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    var color: UIColor = UIColor.gray
    var myBrush = Brush(size: 20, color: .blue , type: 3)
    
    @IBAction func deleteButtonPressed() {
        let subviews = self.sketchView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    @IBAction func backButtonPressed () {
        let subviews = self.sketchView.subviews
        let lastView = subviews.last
        lastView?.removeFromSuperview()
    }
    
    @IBAction func formButtonPressed (_ sender: UIButton) {
        myBrush.type = sender.tag
    }

    @IBAction func sliderPressed(_ sender: UISlider) {
        myBrush.size = sender.value
    }
    
    @IBAction func pickColorButtonPressed(_ sender: UIButton) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
    @IBAction func takeScreenShot() {
        if let myImage = captureView(view: sketchView) {
            
            UIImageWriteToSavedPhotosAlbum(myImage, self, #selector(MainViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    // capture d'une view et de son contenu
    // dans notre appli, il faut dessiner dans cette vue pour que celà fonctionne
    func captureView(view : UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0);
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext();
            return image
        } else {
            return nil
        }
    }
    
    // fonction appelée à la fin de la sauvegarde de l'image dans la pellicule photo de l'appareil
    // image un message en fonction du succès ou non
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.sketchView)
            choiceType(position: position)
            beganFiguresLabel.text = "x = \(position.x), y = \(position.y)"
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: sketchView)
            choiceType(position: position)
            movedFiguresLabel.text = "x = \(position.x), y = \(position.y)"
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: sketchView)
            choiceType(position: position)
            endFiguresLabel.text = "x = \(position.x), y = \(position.y)"
        }
    }
    
    func drawSquare (inView: UIView, position: CGPoint, size: CGFloat, color: UIColor) {
        let myRect = CGRect(x: position.x - (size/2), y: position.y - (size/2), width: size, height: size)
        let myView = UIView(frame: myRect)
        myView.backgroundColor = color
        inView.addSubview(myView)
        }
    
    func drawCircle (into inView: UIView, position: CGPoint, size: CGFloat, color: UIColor) {
        let myRect = CGRect(x: position.x - (size/2), y: position.y - (size/2), width: size, height: size)
        let myView = UIView(frame: myRect)
        myView.layer.cornerRadius = size/2
        myView.backgroundColor = color
        inView.addSubview(myView)
    }
    
    func drawImage (into inView: UIView, position: CGPoint, size: CGFloat, color: UIColor) {
        let myRect = CGRect(x: position.x - (size/2), y: position.y - (size/2), width: size, height: size)
        let myView = UIImageView(frame: myRect)
        myView.image = #imageLiteral(resourceName: "fleche-droite_318-133548")
        myView.tintColor = color
        inView.addSubview(myView)
    }
    
    func choiceType (position: CGPoint) {
        switch myBrush.type {
        case 3:
            drawCircle(into: self.sketchView, position: position, size: CGFloat(myBrush.size), color: myBrush.color)
        case 4:
            drawSquare(inView: self.sketchView, position: position, size: CGFloat(myBrush.size), color: myBrush.color)
        case 5:
            drawImage(into: self.sketchView, position: position, size: CGFloat(myBrush.size), color: myBrush.color)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sketchView.layer.cornerRadius = 10
        sketchView.layer.borderWidth = 2
        deleteButton.setTitle(FontAwesomeIcons.delete.rawValue, for: .normal)
        backButton.setTitle(FontAwesomeIcons.back.rawValue, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let alertController = UIAlertController(title: "Titre de mon controller", message: "Je suis le message de mon controller", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {action in
            print ("Je fais qqch")
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MainViewController: UIPopoverPresentationControllerDelegate {
    
    func colorDidChange(_ color: UIColor) {
        myBrush.color = color
    }
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
}

