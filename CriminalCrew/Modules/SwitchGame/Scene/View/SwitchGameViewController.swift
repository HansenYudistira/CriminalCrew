//
//  SwitchGameViewController.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import UIKit

class SwitchGameViewController: UIViewController {
    
    var viewModel: SwitchGameViewModel!
    var coordinator: SwitchGameCoordinator?
    
    private var completeTaskButton: UIButton!
    private var notifyCoordinatorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        let repository = MultipeerTaskRepository()
        let useCase = SwitchGameUseCase(taskRepository: repository)
        self.viewModel = SwitchGameViewModel(switchGameUseCase: useCase)
        
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        completeTaskButton = UIButton(type: .system)
        completeTaskButton.setTitle("Complete Task", for: .normal)
        completeTaskButton.addTarget(self, action: #selector(didCompleteTask), for: .touchUpInside)
        
        view.addSubview(completeTaskButton)
        
        notifyCoordinatorButton = UIButton(type: .system)
        notifyCoordinatorButton.setTitle("Notify Coordinator", for: .normal)
        notifyCoordinatorButton.addTarget(self, action: #selector(didCompleteQuickTimeEvent), for: .touchUpInside)
        
        view.addSubview(notifyCoordinatorButton)
        
        completeTaskButton.translatesAutoresizingMaskIntoConstraints = false
        notifyCoordinatorButton.translatesAutoresizingMaskIntoConstraints = false
        completeTaskButton.anchor(top: view.centerYAnchor)
        notifyCoordinatorButton.anchor(top: completeTaskButton.bottomAnchor, paddingTop: 20)
    }
    
    private func bindViewModel() {
        viewModel.taskCompletionStatusChanged = { [weak self] isSuccess in
            if isSuccess {
                self?.showTaskCompletionAlert()
            } else {
                self?.showErrorAlert()
            }
        }
    }

    @objc private func didCompleteTask() {
        viewModel.completeTask()
    }
    
    @objc private func didCompleteQuickTimeEvent() {
        coordinator?.handleTaskCompletion()
    }

    private func showTaskCompletionAlert() {
        let alert = UIAlertController(title: "Task Completed", message: "Task has been completed and sent to another device.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to complete the task.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

