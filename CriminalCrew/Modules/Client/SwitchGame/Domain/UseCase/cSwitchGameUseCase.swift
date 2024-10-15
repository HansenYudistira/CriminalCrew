//
//  SwitchGameUseCase.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import Foundation
import Combine

protocol ValidateGameUseCaseProtocol {
    
    func validateGameLogic(pressedButtons: [String]) -> AnyPublisher<Bool, Error>
    func validateGameLogic(pressedButtons: [[String]]) -> AnyPublisher<Bool, Error>
    
}

internal class SwitchGameUseCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let taskRepository: TaskRepository
    private var newTask: NewTask
    private var taskDone: TaskDone
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
        newTask = NewTask(payload: ["taskId": "1", "TaskToBeDone": ["Red", "Quantum Encryption", "Pseudo AIIDS"]])
        taskDone = TaskDone(payload: [:])
    }
    
    internal func completeTask() -> AnyPublisher<Bool, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            let updatedTaskDone = self.updatedPayloadTaskDone(
                newPayload: [
                    "taskId": newTask.payload["taskId"] ?? "",
                    "isCompleted": true,
                    "id": taskDone.id,
                    "instanciatedOn": newTask.instanciatedOn
                ]
            )
            
            self.taskRepository.sendTaskDataToPeer(taskDone: updatedTaskDone)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            promise(.failure(error))
                    }
                }, receiveValue: { success in
                    promise(.success(success))
                })
                .store(in: &cancellables)
            }
            .eraseToAnyPublisher()
    }
    
    private func updatedPayloadTaskDone(newPayload: [String: Any]) -> TaskDone {
        return TaskDone.construct(from: newPayload)!
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
}

extension SwitchGameUseCase: ValidateGameUseCaseProtocol {
    
    internal func validateGameLogic(pressedButtons: [String]) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            promise(.success(self.newTask == pressedButtons))
        }
        .eraseToAnyPublisher()
    }
    
    internal func validateGameLogic(pressedButtons: [[String]]) -> AnyPublisher<Bool, Error> {
        return Future { [weak self] promise in
            guard let self = self else { return }
            promise(.success(self.newTask == pressedButtons))
        }
        .eraseToAnyPublisher()
    }
    
}
