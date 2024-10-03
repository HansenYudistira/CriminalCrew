//
//  SwitchGameUseCase.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import Foundation
import Combine

class SwitchGameUseCase {
    
    private let taskRepository: TaskRepository
    var newTask: NewTask
    var taskDone: TaskDone
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
        newTask = NewTask(purpose: "SwitchTask", time: Date.now, payload: ["taskId": "1", "TaskToBeDone": [1,5,9,13]])
        taskDone = TaskDone(purpose: "SendTaskReport", time: Date.now, payload: [:])
    }
    
    func completeTask(completion: @escaping (Bool) -> Void) {
        taskDone.payload["taskId"] = newTask.payload["taskId"]
        taskDone.payload["isCompleted"] = true
        taskDone.payload["timestamp"] = Date.now
        taskRepository.sendTaskDataToPeer(taskDone: taskDone) { isSuccess in
            completion(isSuccess)
        }
    }
    
    func validateGameLogic(pressedButtons: [Int]) -> Bool {
        return newTask == pressedButtons
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
