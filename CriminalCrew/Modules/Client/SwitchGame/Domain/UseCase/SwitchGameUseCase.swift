//
//  SwitchGameUseCase.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import Foundation
import Combine

protocol ValidateGameUseCaseProtocol {
    func validateGameLogic(pressedButtons: [String]) -> Bool
    func validateGameLogic(pressedButtons: [[String]]) -> Bool
    
}

class SwitchGameUseCase {
    private let taskRepository: TaskRepository
    var newTask: NewTask
    var taskDone: TaskDone
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
        newTask = NewTask(purpose: "SwitchTask", time: Date.now, payload: ["taskId": "1", "TaskToBeDone": ["Quantum Encryption", "Pseudo AIIDS"]])
        taskDone = TaskDone(time: Date.now, payload: [:])
    }
    
    func completeTask(completion: @escaping (Bool) -> Void) {
        let updatedTaskDone = updatedPayloadTaskDone(
            oldtime: newTask.time,
            newPayload: [
                "taskId": newTask.payload["taskId"] ?? "",
                "isCompleted": true,
                "timestamp": Date.now,
                "purpose": taskDone.purpose,
                "time": newTask.time
            ]
        )
        taskRepository.sendTaskDataToPeer(taskDone: updatedTaskDone) { isSuccess in
            completion(isSuccess)
        }
    }
    
    func updatedPayloadTaskDone(oldtime: Date, newPayload: [String: Any]) -> TaskDone {
        return TaskDone(time: oldtime, payload: newPayload)
    }
}

extension SwitchGameUseCase: ValidateGameUseCaseProtocol {
    func validateGameLogic(pressedButtons: [String]) -> Bool {
        return newTask == pressedButtons
    }
    
    func validateGameLogic(pressedButtons: [[String]]) -> Bool {
        return newTask == pressedButtons
    }
}
