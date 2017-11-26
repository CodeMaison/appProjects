//
//  Utilities.swift
//  minuteur
//
//  Created by etudiant21 on 19/10/2017.
//  Copyright © 2017 AnneLaure. All rights reserved.
//

import Foundation

import UserNotifications

import UIKit


/// enregister l'autorisation pour les notifications
func registerForNotifications() {
    
    UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]]
        , completionHandler: { (granted, error) in
            NSLog("granted=\(granted)")
    })
    
}

/// fonction pour programmer une local notification dans lefutur
func scheduleLocalNotification(delay: TimeInterval, body: String, title: String? = nil, subtitle: String? = nil, soundName: String? = nil) {
    
    let content = UNMutableNotificationContent()
    content.body = body
    
    if title != nil {
        content.title = title!
    }
    
    if soundName != nil {
        content.sound = UNNotificationSound(named: soundName!)
    }
    
    if subtitle != nil {
        content.subtitle = subtitle!
    }
    //  content.launchImageName = "croix"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay,
                                                    repeats: false)
    
    let request = UNNotificationRequest(identifier: "demoNotification",
                                        content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request,
                                           withCompletionHandler: { (error) in
                                            // Handle error
                                            
    })
}
