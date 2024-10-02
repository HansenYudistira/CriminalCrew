//
//  SwitchGameViewController.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import UIKit

class SwitchGameViewController: UIViewController {
    
    var viewModel: SwitchGameViewModel!
    var coordinator: RootCoordinator?
    
    private var gridStackView: UIStackView!
    private var gridButtons: [[UIButton]] = []
    
    private var notifyCoordinatorButton: UIButton!
    
    private var pressedButton: [Int] = []
    let validTags = [1, 5, 9, 13]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupGrid()
        
        let repository = MultipeerTaskRepository()
        let useCase = SwitchGameUseCase(taskRepository: repository)
        self.viewModel = SwitchGameViewModel(switchGameUseCase: useCase)
        
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        notifyCoordinatorButton = UIButton(type: .system)
        notifyCoordinatorButton.setTitle("Notify Coordinator", for: .normal)
        notifyCoordinatorButton.addTarget(self, action: #selector(didCompleteQuickTimeEvent), for: .touchUpInside)
        
        view.addSubview(notifyCoordinatorButton)
    }
    
    private func setupGrid() {
        gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 10
        gridStackView.distribution = .fillEqually
        view.addSubview(gridStackView)
        
        gridStackView.centerX(inView: view)
        gridStackView.centerY(inView: view)
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            gridStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])

        for row in 0..<4 {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.distribution = .fillEqually

            var rowButtons: [UIButton] = []
            for column in 0..<4 {
                let button = UIButton(type: .system)

                if let image = UIImage(named: "Lever On")?.withRenderingMode(.alwaysOriginal) {
                    button.setImage(image, for: .normal)
                }
                
                button.imageView?.contentMode = .scaleAspectFit
                
                button.backgroundColor = .clear
                
                button.tag = (row * 4) + column

                button.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)

                rowButtons.append(button)
                rowStackView.addArrangedSubview(button)
            }
            gridButtons.append(rowButtons)
            gridStackView.addArrangedSubview(rowStackView)
        }
    }

    @objc private func toggleButton(_ sender: UIButton) {
        viewModel.toggleButton(tag: sender.tag)
        
        if sender.currentImage == UIImage(named: "Lever On")?.withRenderingMode(.alwaysOriginal) {
            sender.setImage(UIImage(named: "Lever Off")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            sender.setImage(UIImage(named: "Lever On")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
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

