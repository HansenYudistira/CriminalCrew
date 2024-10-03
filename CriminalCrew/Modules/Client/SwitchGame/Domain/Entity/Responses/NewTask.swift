//
//  NewTask.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 02/10/24.
//

import Foundation

struct NewTask {
    let purpose: String
    let time: Date
    var payload: [ String : Any ]
    
    init(purpose: String, time: Date, payload: [String : Any]) {
        self.purpose = purpose
        self.time = time
        self.payload = payload
    }
    
    static func == (lhs: NewTask, rhs: [Int]) -> Bool {
        guard let lhsTask = lhs.payload["TaskToBeDone"] as? [Int] else {
            return false
        }
        
        return lhsTask.sorted() == rhs.sorted()
    }
}
