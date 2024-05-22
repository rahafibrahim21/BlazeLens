//
//  ChallengeModel.swift
//  BlazeLens
//
//  Created by Rahaf ALghuraibi on 14/11/1445 AH.
//

import Foundation
import CloudKit
struct ChallengeModel : Identifiable, Hashable {
    var challengId : CKRecord.ID?
  
    var challengeName : String
    var ChallengeStartDate : Date
    var ChallengeEndDate : Date
    var VotingStartDate : Date
    var VotingEndDate : Date
    //var Posts : [PostModel]
    var id : CKRecord.ID {
        challengId ?? CKRecord.ID(recordName: "")
        
    }
    
    init(record : CKRecord) {
        self.challengId = record.recordID
        self.challengeName = record["challengeName"] as? String ?? "N/A"
        self.ChallengeStartDate = record["ChallengeStartDate"] as? Date ?? Date()
        self.ChallengeEndDate = record["ChallengeEndDate"] as? Date ?? Date()
        self.VotingStartDate = record["VotingStartDate"] as? Date ?? Date()
        self.VotingEndDate = record["VotingEndDate"] as? Date ?? Date()
        
    }
}


