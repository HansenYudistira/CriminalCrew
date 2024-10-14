//
//  SwitchGameCoordinator.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import UIKit

class RootCoordinator {
    private let navigationController: UINavigationController
    private let repository: TaskRepository
    private var switchGameViewController: ClockGameViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.repository = MultipeerTaskRepository()
    }

    func start() {
        let useCase = SwitchGameUseCase(taskRepository: repository)
        let viewModel = SwitchGameViewModel(switchGameUseCase: useCase)

        let switchGameVC = ClockGameViewController(nibName: "ClockGameViewController", bundle: nil)
        switchGameVC.viewModel = viewModel
        switchGameVC.coordinator = self
        
        self.switchGameViewController = switchGameVC
        
        navigationController.pushViewController(switchGameVC, animated: true)
    }

    func handleTaskCompletion() {
        // handle moving to another page if completed (used for quick time event)
        print("task successfully completed")
    }
}
