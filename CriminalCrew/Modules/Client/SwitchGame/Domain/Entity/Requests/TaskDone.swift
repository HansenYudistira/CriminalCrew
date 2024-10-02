//
//  TaskDone.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 02/10/24.
//

import Foundation
import GamePantry

struct TaskDone {
    let purpose: String
    let time: Date
    var payload: [String : Any]
    
    init(purpose: String, time: Date, payload: [String : Any]) {
        self.purpose = purpose
        self.time = time
        self.payload = payload
    }
}

extension TaskDone: GPRepresentableAsData {
    func representedAsData() -> Data {
        let payloadkeys = PayloadKeys.allCases.reduce(into: [String: String]()) { (result, key) in
            result[key.rawValue] = self.payload[key.rawValue] as? String ?? ""
        }
        return dataFrom {
            payloadkeys
        } ?? Data()
    }
}

extension TaskDone: GPEasilyReadableEventPayloadKeys {
    func value(for key: PayloadKeys) -> Any {
        self.payload[key.rawValue]!
    }
    
    enum PayloadKeys : String, CaseIterable {
        case isCompleted = "isCompleted"
        case taskId = "taskId"
        case timestamp = "timestamp"
        case purpose = "purpose"
        case time = "time"
    }
}
