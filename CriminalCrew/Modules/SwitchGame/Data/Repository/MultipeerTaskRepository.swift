//
//  MultipeerTaskRepository.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//
import Foundation

protocol TaskRepository {
    func sendTaskDataToPeer(taskData: String, completion: @escaping (Bool) -> Void)
    // func fetch()
    // func save()
    // func update()
}

class MultipeerTaskRepository: TaskRepository {
    
    func sendTaskDataToPeer(taskData: String, completion: @escaping (Bool) -> Void) {
        print("data sent: \(taskData)")
        completion(true)
    }
}
