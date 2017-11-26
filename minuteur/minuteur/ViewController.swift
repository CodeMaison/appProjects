//
//  ViewController.swift
//  minuteur
//
//  Created by etudiant21 on 18/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import UIKit

import AVFoundation

class ViewController: UIViewController, MinuteurDelegate {
    
    // MARK: - Outlets

    @IBOutlet weak var topTimeConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var phrase: UILabel!
    
    @IBOutlet weak var totalTimePickerViewValueChanged: UIPickerView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: - Variables globales
    
    var maxTimes = [Int] ()
    
    var timer = Timer()
    
    var minuteur: Minuteur!
    
    var topTimeInitialConstraint: CGFloat!
    
    var playerAudio = AVAudioPlayer()
    
    // MARK: - Actions
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        minuteur.updateMinuteur()
        minuteur.status = .started
        updateDisplay()
        scheduleLocalNotification(delay: TimeInterval(minuteur.timeRemaining), body: "Je suis le body", title: "Je suis le title", subtitle: "Je suis le subtitle", soundName: "ring")
        
        UIView.animate(withDuration: 3, animations: {
            
            let translationTransform = CGAffineTransform(translationX: 0, y: 100)
            self.timeLabel.transform = translationTransform
            
        }, completion: { myBool in
            self.timeLabel.transform = CGAffineTransform.identity
        })
        
        /*UIView.animate(withDuration: 2, animations: {
            let translationTransform = CGAffineTransform(translationX: 0, y: -100)
            self.startButton.transform = translationTransform
            
        }, completion: { myBool in
            UIView.animate(withDuration: 2, animations: {
                let rotatetranslationTransform = CGAffineTransform(translationX: 100, y: -100)
                self.startButton.transform = rotatetranslationTransform
            })
        })*/
        
        startButton.scaleAnimation(withDurationscale: 2, withDurationdescale: 2, scaleX: 4, scaleY: 4, myCompletion: {
            NSLog ("Je suis trop forte")
        })
        
        timeLabel.appearFromRight(withDuration: 5)
        
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        minuteur.timer.invalidate()
        minuteur.status = .paused
        updateDisplay()
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        minuteur.stopMinuteur(maxTimes[totalTimePickerViewValueChanged.selectedRow(inComponent: 0)])
        minuteur.timer.invalidate()
        minuteur.status = .stopped
        updateDisplay()
        
    }
    
    // MARK: - Fonctions
    
    func updateDisplay () {
        
        let minutes = (minuteur.timeRemaining % 3600) / 60
        let seconds = minuteur.timeRemaining - (60 * (minuteur.timeRemaining / 60))
        
        if minutes < 10 && seconds < 10 {
        timeLabel.text = "0\(minutes):0\(seconds)"
        } else if minutes < 10 {
        timeLabel.text = "0\(minutes):\(seconds)"
        } else if seconds < 10 {
        timeLabel.text = "\(minutes):0\(seconds)"
        }
        
        switch minuteur.status {
        case .started:
            startButton.isEnabled = false
            pauseButton.isEnabled = true
            stopButton.isEnabled = true
            phrase.isHidden = true
            timeLabel.isHidden = false
            timeLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            totalTimePickerViewValueChanged.isHidden = true
            topTimeConstraint.constant = 200
        case .paused:
            startButton.isEnabled = true
            pauseButton.isEnabled = false
            stopButton.isEnabled = true
            phrase.isHidden = true
            timeLabel.isHidden = false
            timeLabel.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            totalTimePickerViewValueChanged.isHidden = true
            topTimeConstraint.constant = 200
        case .stopped:
            startButton.isEnabled = true
            pauseButton.isEnabled = false
            stopButton.isEnabled = false
            phrase.isHidden = false
            timeLabel.isHidden = true
            totalTimePickerViewValueChanged.isHidden = false
            topTimeConstraint.constant = topTimeInitialConstraint
        }

    }
    
    func playSound(fileName: String, ofType type: String) {
        if let fileUrl = Bundle.main.url(forResource: fileName, withExtension: type) {
            do {
                playerAudio = try AVAudioPlayer(contentsOf: fileUrl)
                playerAudio.prepareToPlay()
                playerAudio.play()
            } catch let error {
                print("audio error:\(error)")
            }
        } else {
            print("error to find file=\(fileName)")
        }
    }
    
    // MARK: - ViewLife Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        maxTimes = stride(from: 10, to: 200, by: 10).map{$0}
        
        /* maxTimes = (10...200).filter {$0 % 10 == 0} */
        
        /*
        (10...200).forEach{
            if $0 % 10 == 0 {
                maxTimes.append($0)
        }*/
        
        /*for index in 10...200 {
            if index % 10 == 0 {
                maxTimes.append(index)
         }
        }*/
        topTimeInitialConstraint = topTimeConstraint.constant
        minuteur = Minuteur(status: .stopped, timeRemaining: 10, timeAtStart: 10)
        minuteur.delegate = self
        minuteur.timeRemaining = maxTimes[0]
        updateDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxTimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(maxTimes [row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        minuteur.timeRemaining = maxTimes [row]
        minuteur.timeAtStart = maxTimes [row]
        updateDisplay()
    }
}

extension UIView {
    
    func scaleAnimation (withDurationscale: Double, withDurationdescale: Double, scaleX: CGFloat, scaleY : CGFloat, myCompletion: @escaping () -> Void) {
        
        UIView.animate(withDuration: withDurationscale, animations: {
            let rescaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            self.transform = rescaleTransform
            
        }, completion: { myBool in
            UIView.animate(withDuration: withDurationdescale, animations: {
                self.transform = CGAffineTransform.identity
                
            }, completion: { myBool in
                myCompletion()
            })
        })
    }
    
    func appearFromRight (withDuration: Double) {
        
        let translationTransform = CGAffineTransform(translationX: UIScreen.main.bounds.width - self.frame.origin.x, y: 0)
        self.transform = translationTransform
        
        UIView.animate(withDuration: withDuration, animations: {
            
            let translationTransform = CGAffineTransform.identity
            self.transform = translationTransform
            
        })
    }
}
