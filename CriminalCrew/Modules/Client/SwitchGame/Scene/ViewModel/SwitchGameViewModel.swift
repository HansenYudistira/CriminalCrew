//
//  SwitchGameViewModel.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import Foundation

class SwitchGameViewModel {
    
    // Dependencies
    private let switchGameUseCase: SwitchGameUseCase
    var pressedButton: [Int] = []
    
    // Callback
    var taskCompletionStatusChanged: ((Bool) -> Void)?
    
    // Init
    init(switchGameUseCase: SwitchGameUseCase) {
        self.switchGameUseCase = switchGameUseCase
    }
    
    func toggleButton(tag: Int) {
        if pressedButton.contains(tag) {
            pressedButton.removeAll { $0 == tag }
        } else {
            pressedButton.append(tag)
        }
        
        let isValid = switchGameUseCase.validateGameLogic(pressedButtons: pressedButton)
        if isValid {
            completeTask()
        }
    }
    
    func completeTask() {
        switchGameUseCase.completeTask { [weak self] isSuccess in
            self?.taskCompletionStatusChanged?(isSuccess)
        }
    }
}
