//
//  BlazeLensApp.swift
//  BlazeLens
//
//  Created by Rahaf ALghuraibi on 14/11/1445 AH.
//

import SwiftUI

@main
struct BlazeLensApp: App {
    @StateObject var VM = ChallengeViewModel()
    init() {
          NotificationManager.shared.requestAuthorization()
      }
    var body: some Scene {
        WindowGroup {
            SplashView().environmentObject(VM)
        }
    }
}
