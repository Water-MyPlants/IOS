//
//  Monkey.swift
//  Water da Plants
//
//  Created by William Chen on 10/22/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import UserNotifications
import CoreData

struct NotificationHelper {
    

    //we are pro swifties!!!
    static func requestLocalNotificationPermissions() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if let error = error {
                    NSLog("Error gaining permission for local notifications")
                }
                
                if !granted {
                    // Present an alert saying the functionality of the app will be limited
                }
                
                // You don't have to schedule the notifications here. This was just for testing.
                //            self.scheduleNotification(at: Date().addingTimeInterval(10))
        }
    }
    
    static func scheduleNotification(at timeInterval: TimeInterval, for plant: Plant) {
        
        
        
        
        guard let plantUUID = plant.id,
            let plantName = plant.nickName
            else { return }
        let identifier = plantUUID
        
        // Content
        
        
        let content = UNMutableNotificationContent()
        
        content.title = "Time to water the \(plantName)"
        content.subtitle = "This is the subtitle"
        content.body = "This is the body"
        content.sound = UNNotificationSound.default
        
        // Trigger
        
        let timeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        
        //        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        //
        //        let calenderTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: timeIntervalTrigger)
        
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                NSLog("Error scheduling notification: \(identifier): \(error)")
            }
            
        }
    }
    
  static func getTimeRemainingForPlant(for plant: Plant, completion: @escaping (TimeInterval?) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            guard let id = plant.id else {
                completion(nil)
                return
            }
            let plantRequest = requests.filter({$0.identifier == id}).first
            guard let trigger = plantRequest?.trigger as? UNTimeIntervalNotificationTrigger else {
                completion(nil)
                return
            }
            let triggerDate = trigger.nextTriggerDate()
            completion(triggerDate?.timeIntervalSinceNow)
        }
    }
}

    
