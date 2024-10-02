//
//  SwitchGameUseCase.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import Foundation

class SwitchGameUseCase {
    
    private let taskRepository: TaskRepository
    var newTask: NewTask
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
        newTask = NewTask(purpose: "SwitchTask", time: Date.now, payload: ["taskId": "1", "TaskToBeDone": [1,5,9,13]])
    }
    
    func completeTask(completion: @escaping (Bool) -> Void) {
        taskRepository.sendTaskDataToPeer(taskData: "Task completed") { isSuccess in
            completion(isSuccess)
        }
    }
    
    func validateGameLogic(pressedButtons: [Int]) -> Bool {
        var validTask = newTask
        validTask.payload["TaskToBeDone"] = pressedButtons
        
        return newTask == validTask
    }
}

/// struct entityReq {
/// purpose : string
/// time : Date
/// payload : [String : Any] => taskId, isCompleted, timestamp
/// }
///
/// struct entityRes {
/// purpose: string
/// time: Date
/// payload" [String : Any] => taskId, whatTaskToBeDone [Int]
/// }
///
/// struct entitiyGame {
///  untuk validasi game logic
/// }
