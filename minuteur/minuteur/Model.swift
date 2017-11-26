//
//  Model.swift
//  minuteur
//
//  Created by etudiant21 on 18/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation

enum MinuteurStatus {
    case started
    case paused
    case stopped
}

protocol MinuteurDelegate {
    func updateDisplay()
    func playSound(fileName: String, ofType type: String)
}

class Minuteur {
    var timer = Timer ()
    var status: MinuteurStatus
    var timeRemaining: Int
    var timeAtStart: Int
    var delegate: MinuteurDelegate?
    /*func stopMinuteur() {
        if let index = delegate?.maxTimes.index(of: timeAtStart) {
            timeRemaining = delegate!.maxTimes[index]
        }
    }*/
    func stopMinuteur (_ selectedRowValue: Int) {
            timeRemaining = selectedRowValue
    }
    func updateMinuteur () {
        timeRemaining -= 1
        print ("Il reste \(timeRemaining) secondes avant la fin")
        delegate?.updateDisplay()
        if timeRemaining > 0 {
            delegate?.updateDisplay()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {timer in self.updateMinuteur()})
        } else {
            delegate?.playSound(fileName: "ring", ofType: "mp3")
            self.timer.invalidate()
            status = .stopped
            delegate?.updateDisplay()
        }
    }
    init (status: MinuteurStatus, timeRemaining: Int, timeAtStart: Int){
        self.status = status
        self.timeRemaining = timeRemaining
        self.timeAtStart = timeAtStart
    }
}
