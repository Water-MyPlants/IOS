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

var plant: Plant?
extension LoginViewController{
 
    
//we are pro swifties!!!
func requestLocalNotificationPermissions() {
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
            self.scheduleNotification(at: Date().addingTimeInterval(10))
    }
}
    func scheduleNotification(at date: Date) {

           // Identifier - A way to uniquely identify one notification from the other

           // Make this unique to the plant you want to water.
           // Add a UUID to your plant

           let plantUUID = UUID().uuidString

           let identifier = plantUUID

           // Content

        let plantName = plant?.nickName

           let content = UNMutableNotificationContent()

           content.title = "Time to water the \(plantName)"
           content.subtitle = "This is the subtitle"
           content.body = "This is the body"
           content.sound = UNNotificationSound.default

           // Trigger
           let timeOffset = date.timeIntervalSince1970 - Date().timeIntervalSince1970

           let timeIntervalTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeOffset, repeats: false)

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
    func scheduleDailyReminderNotification(name: String, times: Date, calendar: Calendar) {
           let df = TimeInterval()
        df = .none
           df.timeStyle = .short
           let time = df.string(from: times)
           let dateComponents = calendar.dateComponents([.hour, .minute], from: times)
           let content = UNMutableNotificationContent()
           content.title = "It's time to water \(name)."
           content.body = "It's \(time)! \(name) is getting thirsty."
           let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
           let request = UNNotificationRequest(identifier: "PlantIdentifier", content: content, trigger: trigger)
           let center = UNUserNotificationCenter.current()
        center.delegate = self as? UNUserNotificationCenterDelegate
           center.add(request) { (error) in
               if let error = error {
                   print("There was an error scheduling a notification: \(error)")
                   return
            }
        }
    }
}
