//
//  SwitchGameViewModel.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import Foundation

class SwitchGameViewModel {
    
    private let switchGameUseCase: SwitchGameUseCase
    var pressedButton: [String] = []
    
    var taskCompletionStatusChanged: ((Bool) -> Void)?
    
    init(switchGameUseCase: SwitchGameUseCase) {
        self.switchGameUseCase = switchGameUseCase
    }
    
    func toggleButton(label: String) {
        if pressedButton.contains(label) {
            pressedButton.removeAll { $0 == label }
        } else {
            pressedButton.append(label)
        }
        
        let isValid = switchGameUseCase.validateGameLogic(pressedButtons: pressedButton)
        if isValid {
            completeTask()
        } else {
            wrongAnswer()
        }
    }
    
    func completeTask() {
        switchGameUseCase.completeTask { [weak self] isSuccess in
            self?.taskCompletionStatusChanged?(isSuccess)
        }
    }
    
    func wrongAnswer() {
        self.taskCompletionStatusChanged?(false)
    }
}
