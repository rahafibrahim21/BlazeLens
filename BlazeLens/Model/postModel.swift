//
//  postModel.swift
//  BlazeLens
//
//  Created by Rahaf ALghuraibi on 14/11/1445 AH.
//


import SwiftUI
import UserNotifications
import Foundation
import CloudKit
struct postModel: Identifiable, Hashable {
    let id: CKRecord.ID
    var voting_Counter: Int
    let photo: CKAsset?
    let user_id: String
    let challengeId: CKRecord.Reference?
    //CKRecord.ID?//Here Ghalia
    let playerName : String
    
    
    init(record: CKRecord) {
        self.id = record.recordID
        self.voting_Counter = record["voting_Counter"] as? Int ?? 0
        self.photo = record["photo"] as? CKAsset
        self.user_id = record["user_id"] as? String ?? "N/A"
        "N/A"
        self.playerName = record["playerName"] as? String ?? "N/A"
        "N/A"
        
        self.challengeId = record["challengeId"] as? CKRecord.Reference
        //record["challengeId"] as? CKRecord.ID // Assuming you set this field in your database //Here Ghalia
        
       // ?? CKRecord.ID(recordName: "")
           }
    }

//import CloudKit
//
//
//struct postModel: Identifiable {
//    let id: CKRecord.ID
//    var voting_Counter: Int  // Change to var
//    let photo: CKAsset?
//    let user_id: CKRecord.Reference?
//    let playerName: String
//    let challengeId: CKRecord.Reference?
//    
//    init(record: CKRecord) {
//        self.id = record.recordID
//        self.voting_Counter = record["voting_Counter"] as? Int ?? 0
//        self.photo = record["photo"] as? CKAsset
//        self.user_id = record["user_id"] as? CKRecord.Reference
//        self.playerName = record["playerName"] as? String ?? "Unknown"
//        self.challengeId = record["challengeId"] as? CKRecord.Reference
//    }
//}

