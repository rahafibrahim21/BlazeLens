//
//  ExploreView.swift
//  BlazeLens
//
//  Created by Rahaf ALghuraibi on 14/11/1445 AH.
//

import UIKit



import SwiftUI
import CloudKit
import GameKit
struct ExploreView: View {
    
    @StateObject var ChallengeVM = ChallengeViewModel()
    @StateObject var viewModel = postViewModel()
    @State private var gameCenterScore: Int = 0
    @State private var isGameCenterAuthenticated = false
    
    @State private var currentPlayerID: String?
    
    @State private var totalVoting: Int = 0
    
    
    // @State var x : String
    @State var buttonText: String = ""
    
    @State var ButtonAppear : Bool = false
    
    @State var selectedChallenge: ChallengeModel?
    
    @State var ChallangeFinieshed  : Bool = false
    
    //@State private var playerID: String = ""
    @State private var profileImage: UIImage?
    @EnvironmentObject var voteData: postViewModel
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color(.backgroungC)
                    .ignoresSafeArea()
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Explore")
                                    .bold()
                            }
                        }
                        ToolbarItemGroup(placement: .primaryAction) {
                            NavigationLink {
                                userProfile()
                            } label: {
                                if let profileImage = profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                } else {
                                    // Placeholder image or loading indicator
                                    Text("Loading profile image...")
                                }
                                
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                calculateTotalVotingCount()
                                displayLeaderboard()
                            }) {
                                Image("winner")
                                    .resizable()
                                    .padding(.leading, 5.0)
                                    .frame(width: 45, height: 35)
                                    .foregroundColor(Color(red: 1, green: 0.55, blue: 0.26))
                            }
                        }
                    }
                
                    .ignoresSafeArea()
                
                
                
                VStack {
                    Text("")
                    let currentDate = Date()
                    Text("Today's challenge :").multilineTextAlignment(.leading)
                        .padding(.trailing, 200)
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 291, height: 138)
                            .foregroundStyle(Color(red: 0.95, green: 0.98, blue: 0.98))
                        
                        VStack {
                            ForEach(ChallengeVM.Challenges.indices, id: \.self) { index in
                                let challenge = ChallengeVM.Challenges[index]
                                
                                if challenge.ChallengeStartDate < currentDate && currentDate < challenge.VotingEndDate {
                                    ChallengeRow(challenge: challenge, currentDate: currentDate)
                                } else if currentDate >= challenge.VotingEndDate {
                                    // Check if there is a next challenge
                                    if index + 1 < ChallengeVM.Challenges.count {
                                        let nextChallenge = ChallengeVM.Challenges[index + 1]
                                        
                                        // Check if currentDate is between the current challenge's VotingEndDate and the start date of the next challenge
                                        if currentDate >= challenge.VotingEndDate && currentDate
                                            < nextChallenge.ChallengeStartDate {
                                            Text("Time out wait for next")
                                        }
                                    }
                                    //                                else {
                                    //                                    // If this is the last challenge and currentDate is past its VotingEndDate
                                    //                                    Text("Time out , no more challange")
                                    //                                }
                                }
                                
                            }
                            
                            
                            //                        ForEach(ChallengeVM.Challenges.indices, id: \.self) { index in
                            //                            let challenge = ChallengeVM.Challenges[index]
                            //
                            //                            let high = viewModel.posts.filter { $0.challengeId?.recordID == challenge.id }
                            //                            if let highestVotedPost = viewModel.highestVotedPost(posts: high) {
                            //                                Text("Highest voted photo: \(highestVotedPost.voting_Counter)")
                            //                            } else {
                            //                                Text("No posts found for this challenge")
                            //                            }
                            //                        }
                            
                            
                            
                            
                        }
                    }
                    
                    VStack{
                        Text("Explore past challenges:")
                            .font(Font.custom("SF Pro", size: 16).weight(.bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.trailing, 200)
                            .padding(.top, 10)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (spacing: 10){
                                ForEach(ChallengeVM.Challenges.indices, id: \.self) { index in
                                    let challenge = ChallengeVM.Challenges[index]
                                    //Text ("\(challenge.challengeName)")
                                    
                                    
                                    //                                      let high = viewModel.posts.filter { $0.challengeId?.recordID == challenge.id }
                                    let high = viewModel.posts.filter {
                                        if let challengeId = $0.challengeId?.recordID.recordName {
                                            return challengeId == challenge.challengId?.recordName
                                        }
                                        return false
                                    }
                                    if let highestVotedPost = viewModel.highestVotedPost(posts: high) {
                                        //Text("Highest voted photo: \(highestVotedPost.voting_Counter)")
                                        exploreCard(highestVotedPost: highestVotedPost, challenge: challenge)
                                        
                                    } else {
                                        Text("No posts found for this challenge")
                                    }
                                }
                            }
                        }
                        
                        
                    }
                }
            }.onAppear {
                // Fetch challenges only if not already fetched
                if ChallengeVM.Challenges.isEmpty {
                    ChallengeVM.fetchChallenges()
                }
                authenticateWithGameCenter()
                loadProfilePhoto()
                if (isGameCenterAuthenticated){
                    calculateTotalVotingCount()
                    viewModel.fetchposts()
                }
                else {
                    authenticateWithGameCenter()
                    
                }
            }.navigationBarBackButtonHidden(true)
        }
        
    }
        func loadGameCenterScore() {
            guard isGameCenterAuthenticated else {
                print("Cannot load Game Center score. User not authenticated.")
                return
            }
            
            let leaderboardID = "0802"
            let scoreRequest = GKLeaderboard(players: [GKLocalPlayer.local])
            scoreRequest.identifier = leaderboardID
            
            scoreRequest.loadScores { scores, error in
                if let error = error {
                    print("Failed to load Game Center scores: \(error.localizedDescription)")
                } else if let score = scoreRequest.localPlayerScore {
                    gameCenterScore = Int(score.value)
                    print("Game Center score loaded: \(gameCenterScore)")
                }
            }
        }
        func displayLeaderboard() {
            loadGameCenterScore()
            let gcViewController = GKGameCenterViewController()
            gcViewController.leaderboardIdentifier = "0802"
            gcViewController.viewState = .leaderboards
            gcViewController.gameCenterDelegate = makeCoordinator()
            UIApplication.shared.windows.first?.rootViewController?.present(gcViewController, animated: true, completion: nil)
        }
        
        func authenticateWithGameCenter() {
            GKLocalPlayer.local.authenticateHandler = { viewController, error in
                if let viewController = viewController {
                    UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
                } else if let error = error {
                    print("Game Center authentication failed with error: \(error.localizedDescription)")
                } else {
                    print("Local player authenticated")
                    isGameCenterAuthenticated = true
                    currentPlayerID = GKLocalPlayer.local.playerID
                    loadProfilePhoto()
                    calculateTotalVotingCount()
                    savePlayerIDToCloudKit()
                    // Set currentPlayerID upon successful authentication
                    //   calculateTotalVotingCount() // Calculate the total voting count once the player ID is set
                }
            }
        }
        
        func calculateTotalVotingCount() {
            guard let currentPlayerID = currentPlayerID else {
                print("Current player ID is nil.")
                return
            }
            
            // Filter posts for the current user using the player ID
            let currentUserPosts = viewModel.posts.filter { $0.user_id == currentPlayerID }
            
            // Calculate total voting count for the user's posts
            totalVoting = currentUserPosts.reduce(0) { $0 + $1.voting_Counter }
            
            // Update the Game Center score with the new voting count
            print(totalVoting)
            updateGameCenterScore(score: totalVoting)
        }
        
        
        func updateGameCenterScore(score: Int) {
            guard isGameCenterAuthenticated else {
                print("Cannot submit score to Game Center. User not authenticated.")
                return
            }
            
            let scoreReporter = GKScore(leaderboardIdentifier: "0802")
            scoreReporter.value = Int64(score)
            
            GKScore.report([scoreReporter]) { error in
                if let error = error {
                    print("Failed to report score to Game Center: \(error.localizedDescription)")
                } else {
                    print("Score \(score) submitted to Game Center")
                    gameCenterScore = score // Update local gameCenterScore state
                }
            }
        }
        
        
        func loadProfilePhoto() {
            GKLocalPlayer.local.loadPhoto(for: .normal) { (photo, error) in
                if let photo = photo {
                    DispatchQueue.main.async {
                        self.profileImage = photo
                    }
                }
            }
            
            
        }
        
        // Coordinator for Game Center
        class Coordinator: NSObject, GKGameCenterControllerDelegate {
            func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
                gameCenterViewController.dismiss(animated: true, completion: nil)
            }
        }
        
        // Create the coordinator
        func makeCoordinator() -> Coordinator {
            return Coordinator()
        }
    func savePlayerIDToCloudKit() {
            let player = GKLocalPlayer.local
            let playerID = player.playerID ?? ""
            let playerName = player.displayName
    
            // Load the player's photo
            player.loadPhoto(for: .normal) { (photo, error) in
                if let error = error {
                    print("Error loading player photo: \(error.localizedDescription)")
                } else if let photo = photo {
                    // Convert the UIImage to a CKAsset
                    if let photoAsset = self.photoToCKAsset(selectedImage: photo) {
                        // Create a CKRecord and save the player's data
                        let recordID = CKRecord.ID(recordName: UUID().uuidString)
                        let record = CKRecord(recordType: "Player", recordID: recordID)
                        record["playerID"] = playerID
                        record["playerName"] = playerName
                        record["playerPhoto"] = photoAsset
    
                        let container = CKContainer(identifier: "iCloud.R.BlazeLens")
                        container.publicCloudDatabase.save(record) { (record, error) in
                            if let error = error {
                                print("Error saving player data: \(error.localizedDescription)")
    
    
                            } else {
                                print("Player data saved successfully")
    
//                                NavigationLink(destination: AddingPointsView()) {
//                                    Text("PointsView")
//                                }
                            }
                            //                else {
                            //                    print("Error converting UIImage to CKAsset")
                            //                }
                        }
                    }
                }}}
    
    func photoToCKAsset(selectedImage: UIImage?) -> CKAsset? {
        guard let selectedImage = selectedImage,
              let imageData = selectedImage.pngData() else {
            return nil
        }
        
        guard let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        let fileName = "asset#\(UUID().uuidString)"
        guard let imageFilePath = NSURL(fileURLWithPath: documentDirectory)
            .appendingPathComponent(fileName)
        else {
            return nil
        }
        
        do {
            try imageData.write(to: imageFilePath)
            return CKAsset(fileURL: imageFilePath)
        } catch {
            print("Error converting UIImage to CKAsset!")
            return nil
        }
    }
    }
    

    
    //let challengePosts = viewModel.posts.filter { $0.challengeId == challenge.challengId }
    //
    //    if let highestVotedPost = challengePosts.max(by: { $0.voting_Counter < $1.voting_Counter }) {
    //        Text("Highest voted photo: \(highestVotedPost.photoURL)")
    //    }
    
    struct ChallengeRow: View {
        let challenge: ChallengeModel
        let currentDate: Date
        @State private var isJoinable: Bool = false
        @State private var isVotable: Bool = false
        var A : String = "Challenge time out"
        
        var body: some View {
            VStack {
                if isJoinable {
                    ChallengeItemView(challenge: challenge, buttonText: "Join")
                } else if isVotable {
                    ChallengeItemView(challenge: challenge, buttonText: "Vote")
                } else {
                    Text("Challenge time out")
                        .foregroundColor(.red)
                }
            }.onAppear {
                // Determine joinable and votable states based on current date
                isJoinable = currentDate >= challenge.ChallengeStartDate && currentDate < challenge.ChallengeEndDate
                isVotable = currentDate >= challenge.VotingStartDate && currentDate < challenge.VotingEndDate
            }
            
        }
        
    }
    
    
struct ChallengeItemView: View {
    let challenge: ChallengeModel
    let buttonText: String
    @State private var playerName: String = ""
    @State private var playerID: String = ""
    var body: some View {
        Text (challenge.challengeName).font(.headline)
        
        // Handle button tap action
        NavigationLink (
            destination: determineDestination(),
            label: {
                VStack{
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 80, height: 32)
                            .foregroundColor(Color.blue)
                        
                        Text(buttonText)
                            .font(Font.custom("SF Pro", size: 16).weight(.bold))
                            .lineSpacing(25.60)
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .frame(width: 80, height: 32)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color(red: 0.05, green: 0.23, blue: 0.61), Color(red: 0.24, green: 0.50, blue: 0.85)]), startPoint: .top, endPoint: .bottom)
                            )
                            .cornerRadius(24)
                    }}}
            // Function to determine navigation destination based on button text
        )
        
    }
    
    func determineDestination() -> some View {
        if buttonText == "Vote" {
            return AnyView(votePage(challengeId: challenge.id, challenge: challenge))
        } else {
            return AnyView(ChallengeView(challenge: challenge,playerID: playerID, challengeId: challenge.id, playerName: playerName))
        }
    }
    
    
    
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Riyadh")
        
        return dateFormatter.string(from: date)
    }
    
    
    
    func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Riyadh")
        
        return dateFormatter.string(from: date)
    }
    
}


#Preview {
    NavigationStack{
        ExploreView().environmentObject(ChallengeViewModel())
    }
}
