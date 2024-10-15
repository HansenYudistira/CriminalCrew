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
        switchGameUseCase.validateGameLogic(pressedButtons: pressedButton)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("handle error: \(error)")
                }
            }, receiveValue: { [weak self] isSuccess in
                if isSuccess {
                    self?.completeTask()
                }
                self?.taskCompletionStatus.send(isSuccess)
            })
            .store(in: &cancellables)
    }
    
    private func completeTask() {
        switchGameUseCase.completeTask()
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    self?.taskCompletionStatus.send(false)
                }
            }, receiveValue: { [weak self] isSuccess in
                self?.taskCompletionStatus.send(isSuccess)
            })
            .store(in: &cancellables)
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
