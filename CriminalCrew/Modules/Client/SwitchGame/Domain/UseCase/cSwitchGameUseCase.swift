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

internal class SwitchGameUseCase {
    
    private let taskRepository: TaskRepository
    private var newTask: NewTask
    private var taskDone: TaskDone
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
        newTask = NewTask(payload: ["taskId": "1", "TaskToBeDone": ["Red", "Quantum Encryption", "Pseudo AIIDS"]])
        taskDone = TaskDone(payload: [:])
    }
    
    internal func completeTask(completion: @escaping (Bool) -> Void) {
        let updatedTaskDone = updatedPayloadTaskDone(
            newPayload: [
                "taskId": newTask.payload["taskId"] ?? "",
                "isCompleted": true,
                "id": taskDone.id,
                "instanciatedOn": newTask.instanciatedOn
            ]
        )
        taskRepository.sendTaskDataToPeer(taskDone: updatedTaskDone) { isSuccess in
            completion(isSuccess)
        }
    }
    
    private func updatedPayloadTaskDone(newPayload: [String: Any]) -> TaskDone {
        return TaskDone.construct(from: newPayload)!
    }
    
}

extension SwitchGameUseCase: ValidateGameUseCaseProtocol {
    
    internal func validateGameLogic(pressedButtons: [String]) -> Bool {
        return newTask == pressedButtons
    }
    
    internal func validateGameLogic(pressedButtons: [[String]]) -> Bool {
        return newTask == pressedButtons
    }
    
}
