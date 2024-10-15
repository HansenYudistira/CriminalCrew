//
//  NewTask.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 02/10/24.
//

import Foundation
import GamePantry

internal struct NewTask: GPEvent {
    
    internal var id: String = "NewTask"

    internal let purpose: String = "Get a New Task"
    
    internal var instanciatedOn: Date = .now
    
    internal var payload: [ String : Any ]
    
    init(payload: [String : Any]) {
        self.payload = payload
    }
    
    internal static func == (lhs: NewTask, rhs: [String]) -> Bool {
        guard let lhsTask = lhs.payload["TaskToBeDone"] as? [String] else {
            return false
        }
        
        return Set(lhsTask) == Set(rhs)
    }
    
    internal static func == (lhs: NewTask, rhs: [[String]]) -> Bool {
        guard let lhsTask = lhs.payload["TaskToBeDone"] as? [[String]] else {
            return false
        }
        
        return lhsTask == rhs
    }
    
    internal static func == (lhs: NewTask, rhs: [ String : [String]]) -> Bool {
        guard let lhsTask = lhs.payload["TaskToBeDone"] as? [String : [String]] else {
            return false
        }
        
        return lhsTask == rhs
    }
    
}

extension NewTask: GPReceivableEvent {
    
    internal static func construct(from payload: [String : Any]) -> NewTask? {
        guard let _ = payload["TaskToBeDone"] as? [String] else { return nil }
        return .init(payload: payload)
    }
    
}
