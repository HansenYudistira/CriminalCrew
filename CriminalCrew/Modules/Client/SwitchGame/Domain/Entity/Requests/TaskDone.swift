//
//  TaskDone.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 02/10/24.
//

import Foundation
import GamePantry

struct TaskDone {
    let purpose: String = "SentTaskReport"
    var payload: [String : Any]
    
    init(payload: [String : Any]) {
        self.payload = payload
    }
}

extension TaskDone: GPSendableEvent {
    static func construct(from payload: [String : Any]) -> TaskDone? {
        guard
            let _ : Bool = payload["isCompleted"] as? Bool else { return nil }
        return TaskDone(payload: payload)
    }
    
    var id: String {
        "TaskDone"
    }
    
    var instanciatedOn: Date {
        .now
    }
    
    func value(for key: PayloadKeys) -> Any? {
        self.payload[key.rawValue]!
    }
    
    func representedAsData() -> Data {
        return dataFrom {
            [
                PayloadKeys.instanciatedOn.rawValue: "\(instanciatedOn)",
                PayloadKeys.purpose.rawValue: "\(purpose)",
                PayloadKeys.taskId.rawValue: "\(payload["taskId"] ?? "")",
                PayloadKeys.isCompleted.rawValue: "\(payload["isCompleted"] ?? "")",
                PayloadKeys.timestamp.rawValue: "\(payload["timestamp"] ?? "")"
            ]
        }!
    }
    
    enum PayloadKeys : String, CaseIterable {
        case isCompleted = "isCompleted"
        case taskId = "taskId"
        case timestamp = "timestamp"
        case purpose = "purpose"
        case instanciatedOn = "instanciatedOn"
    }
}
