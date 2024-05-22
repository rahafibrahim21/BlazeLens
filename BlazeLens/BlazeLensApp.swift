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
    var body: some Scene {
        WindowGroup {
            ExploreView().environmentObject(VM)
        }
    }
}
