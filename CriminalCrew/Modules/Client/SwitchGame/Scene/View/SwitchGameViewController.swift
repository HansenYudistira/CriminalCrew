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
    var firstArray = ["Quantum", "Pseudo"]
    var secondArray = ["Encryption", "AIIDS", "Cryptography", "Protocol"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        let repository = MultipeerTaskRepository()
        let useCase = SwitchGameUseCase(taskRepository: repository)
        self.viewModel = SwitchGameViewModel(switchGameUseCase: useCase)
        
        bindViewModel()
        
        setupUI()
        setupGrid()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        notifyCoordinatorButton = UIButton(type: .system)
        notifyCoordinatorButton.setTitle("Notify Coordinator", for: .normal)
        notifyCoordinatorButton.addTarget(self, action: #selector(didCompleteQuickTimeEvent), for: .touchUpInside)
        
        view.addSubview(notifyCoordinatorButton)
    }
    
    private func setupGrid() {
        firstArray.shuffle()
        secondArray.shuffle()
        
        let secondArrayStackView = UIStackView()
        secondArrayStackView.axis = .horizontal
        secondArrayStackView.spacing = 10
        secondArrayStackView.distribution = .fillEqually
        view.addSubview(secondArrayStackView)


        for column in 0..<secondArray.count {
            let label = UILabel()
            label.text = secondArray[column]
            label.textAlignment = .center
            secondArrayStackView.addArrangedSubview(label)
        }

        gridStackView = UIStackView()
        gridStackView.axis = .vertical
        gridStackView.spacing = 10
        gridStackView.distribution = .fillEqually
        view.addSubview(gridStackView)
        
        secondArrayStackView.anchor(bottom: gridStackView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 8, paddingTrailing: 8)
        secondArrayStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
        gridStackView.centerX(inView: view)
        gridStackView.centerY(inView: view)
        gridStackView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingBottom: 8, paddingTrailing: 8)
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            gridStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])

        for row in 0..<firstArray.count {
            let rowContainerStackView = UIStackView()
            rowContainerStackView.axis = .horizontal
            rowContainerStackView.spacing = 10
            rowContainerStackView.distribution = .fillProportionally

            let labelBox = UIView()
            let label = UILabel()
            label.text = firstArray[row]
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            
            labelBox.addSubview(label)
            label.centerXAnchor.constraint(equalTo: labelBox.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: labelBox.centerYAnchor).isActive = true

            labelBox.widthAnchor.constraint(equalToConstant: 100).isActive = true
            labelBox.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            rowContainerStackView.addSubview(labelBox)

            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.distribution = .fillEqually

            var rowButtons: [UIButton] = []
            for column in 0..<secondArray.count {
                let button = UIButton(type: .system)

                if let image = UIImage(named: "Lever On")?.withRenderingMode(.alwaysOriginal) {
                    button.setImage(image, for: .normal)
                }
                
                button.imageView?.contentMode = .scaleAspectFit
                button.backgroundColor = .clear
                button.accessibilityLabel = "\(firstArray[row]) \(secondArray[column])"
                button.tag = 0

                button.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)

                rowButtons.append(button)
                rowStackView.addArrangedSubview(button)
            }
            
            rowContainerStackView.addArrangedSubview(rowStackView)
            gridStackView.addArrangedSubview(rowContainerStackView)
        }
    }

    @objc private func toggleButton(_ sender: UIButton) {
        viewModel.toggleButton(label: sender.accessibilityLabel ?? "")
        
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "Lever Off")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "Lever On")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.tag = 0
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

