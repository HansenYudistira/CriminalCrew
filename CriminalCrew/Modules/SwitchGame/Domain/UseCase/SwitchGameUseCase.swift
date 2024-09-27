//
//  SwitchGameUseCase.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import Foundation

class SwitchGameUseCase {
    
    private let taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func completeTask(completion: @escaping (Bool) -> Void) {
        taskRepository.sendTaskDataToPeer(taskData: "Task completed") { isSuccess in
            completion(isSuccess)
        }
    }
}
