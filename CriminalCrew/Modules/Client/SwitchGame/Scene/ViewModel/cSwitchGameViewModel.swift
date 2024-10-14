//
//  SwitchGameViewModel.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import Foundation
import Combine

internal class SwitchGameViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private let switchGameUseCase: SwitchGameUseCase
    
    private var pressedButton: [String] = []
    internal var taskCompletionStatus = PassthroughSubject<Bool, Never>()
    
    init(switchGameUseCase: SwitchGameUseCase) {
        self.switchGameUseCase = switchGameUseCase
    }
    
    internal struct Input {
        let didPressedButton = PassthroughSubject<String, Never>()
    }
    
    internal let input = Input()
    
    internal func bind() {
        input.didPressedButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] accessibilityLabel in
                self?.toggleButton(label: accessibilityLabel)
                self?.validateTask()
            }
            .store(in: &cancellables)
    }
    
    private func toggleButton(label: String) {
        if pressedButton.contains(label) {
            removeButtonLabel(label)
        } else {
            addButtonLabel(label)
        }
    }
    
    private func addButtonLabel(_ label: String) {
        pressedButton.append(label)
    }
    
    private func removeButtonLabel(_ label: String) {
        pressedButton.removeAll { $0 == label }
    }
    
    private func validateTask() {
        let isValid = switchGameUseCase.validateGameLogic(pressedButtons: pressedButton)
        if isValid {
            completeTask()
        } else {
            wrongAnswer()
        }
    }
    
    private func completeTask() {
        DispatchQueue.global(qos: .background).async {
            self.switchGameUseCase.completeTask { [weak self] isSuccess in
                DispatchQueue.main.async {
                    self?.taskCompletionStatus.send(isSuccess)
                }
            }
        }
    }
    
    private func wrongAnswer() {
        taskCompletionStatus.send(false)
    }
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
}
