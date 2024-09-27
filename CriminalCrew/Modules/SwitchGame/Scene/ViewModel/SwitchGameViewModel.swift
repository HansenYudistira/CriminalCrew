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
    
    // Callback
    var taskCompletionStatusChanged: ((Bool) -> Void)?
    
    // Init
    init(switchGameUseCase: SwitchGameUseCase) {
        self.switchGameUseCase = switchGameUseCase
    }
    
    func completeTask() {
        switchGameUseCase.completeTask { [weak self] isSuccess in
            self?.taskCompletionStatusChanged?(isSuccess)
        }
    }
}
