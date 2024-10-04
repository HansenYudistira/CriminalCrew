//
//  TaskDone.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 02/10/24.
//

import Foundation
import GamePantry

struct TaskDone {
    let purpose: String = "SendTaskReport"
    let time: Date
    var payload: [String : Any]
    
    init(time: Date, payload: [String : Any]) {
        self.time = time
        self.payload = payload
    }
}

extension TaskDone: GPRepresentableAsData {
    func representedAsData() -> Data {
        return dataFrom {
            [
                PayloadKeys.time.rawValue: "\(time)",
                PayloadKeys.purpose.rawValue: "\(purpose)",
                PayloadKeys.taskId.rawValue: "\(payload["taskId"] ?? "")",
                PayloadKeys.isCompleted.rawValue: "\(payload["isCompleted"] ?? "")",
                PayloadKeys.timestamp.rawValue: "\(payload["timestamp"] ?? "")"
            ]
        }!
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
