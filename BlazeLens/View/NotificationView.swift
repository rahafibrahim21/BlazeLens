//
//  NotificationView.swift
//  BlazeLens
//
//  Created by Rahaf ALghuraibi on 16/11/1445 AH.
//
import SwiftUI
import UserNotifications
import CloudKit

//// Singleton class to manage notification-related operations
//class NotificationManager {
//    static let shared = NotificationManager()
//    private init() {}
//    
//    // Function to request notification authorization from the user
//    func requestAuthorization() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            if granted {
//                print("Notification permission granted.")
//            } else if let error = error {
//                print("Failed to request notification permission: \(error)")
//            }
//        }
//    }
//    
//    // Function to schedule a local notification
//    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, identifier: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Failed to schedule notification: \(error)")
//            } else {
//                print("Notification scheduled: \(identifier)")
//            }
//        }
//    }
//}
class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Failed to request notification permission: \(error)")
            }
        }
    }
    
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled: \(identifier)")
            }
        }
    }
}


// Define custom notification names
extension Notification.Name {
    static let userWonSecondPlace = Notification.Name("userWonSecondPlace")
    static let voteTimeStarted = Notification.Name("voteTimeStarted")
}
 
 struct NotificationView: View {
     @StateObject private var viewModel = postViewModel()
     @State private var challengeId: CKRecord.ID = CKRecord.ID(recordName: "YourChallengeID") // Replace with your actual challenge ID
     @State private var topPosts: [postModel] = []
     
     var body: some View {
         VStack(alignment: .leading, spacing: 0) {
             ForEach(viewModel.posts) { post in
                 HStack(alignment: .top, spacing: 10) {
                     HStack(spacing: 0) {
                         if let asset = post.photo, let fileURL = asset.fileURL {
                             AsyncImage(url: fileURL)
                                 .frame(width: 30, height: 38)
                         } else {
                             Image(systemName: "photo")
                                 .frame(width: 30, height: 38)
                         }
                     }
                     .frame(width: 38, height: 38)
                     .cornerRadius(8.50)
                     
                     VStack(alignment: .leading, spacing: 0) {
                         HStack(alignment: .top, spacing: 16) {
                             Text(post.playerName)
                                 .font(Font.custom("SF Pro", size: 15).weight(.bold))
                                 .lineSpacing(20)
                                 .foregroundColor(.black)
                         }
                         .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
                         .frame(maxWidth: .infinity)
                         
                         Text("Votes: \(post.voting_Counter)")
                             .font(Font.custom("SF Pro", size: 15))
                             .lineSpacing(20)
                             .foregroundColor(.black)
                     }
                     .frame(maxWidth: .infinity, maxHeight: .infinity)
                 }
                 .padding(EdgeInsets(top: 14, leading: 14, bottom: 12, trailing: 14))
                 .frame(maxWidth: .infinity)
                 .background(Color("BackgroundColor"))
                 .cornerRadius(24)
             }
         }
         .frame(width: 377, height: 300)
         .navigationBarBackButtonHidden(true)
         .onAppear {
             viewModel.fetchTopPosts(for: challengeId) { posts, error in
                 if let posts = posts {
                     topPosts = posts
                 } else if let error = error {
                     print("Error fetching top posts: \(error.localizedDescription)")
                 }
             }
         }
         .padding()
         
         VStack {
             Button("Fetch Top Posts") {
                 viewModel.fetchTopPosts(for: challengeId) { posts, error in
                     if let posts = posts {
                         topPosts = posts
                     } else if let error = error {
                         print("Error fetching top posts: \(error.localizedDescription)")
                     }
                 }
             }
         }
     }
 }




#Preview {
    NotificationView()
}

