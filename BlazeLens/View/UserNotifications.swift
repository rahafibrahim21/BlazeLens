//
//  UserNotifications.swift
//  BlazeLens
//
//  Created by Rahaf ALghuraibi on 16/11/1445 AH.
//
//import SwiftUI
//import UserNotifications
//
//// Singleton class to manage notification-related operations
//class NotificationManager {
//    // Shared instance for the singleton pattern
//    static let shared = NotificationManager()
//    
//    // Private initializer to prevent multiple instances
//    private init() {}
//    
//    // Function to request notification authorization from the user
//    func requestAuthorization() {
//        // Requesting permission for alert, badge, and sound notifications
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            if granted {
//                // Permission granted
//                print("Notification permission granted.")
//            } else if let error = error {
//                // Handle error if permission request failed
//                print("Failed to request notification permission: \(error)")
//            }
//        }
//    }
//    
//    // Function to schedule a local notification
//    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, identifier: String) {
//        // Creating the content of the notification
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        
//        // Setting the trigger for the notification to fire after a time interval
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//        
//        // Creating a request with the content and trigger
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        // Adding the notification request to the notification center
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                // Handle error if adding the request failed
//                print("Failed to schedule notification: \(error)")
//            } else {
//                // Notification scheduled successfully
//                print("Notification scheduled: \(identifier)")
//            }
//        }
//    }
//}
