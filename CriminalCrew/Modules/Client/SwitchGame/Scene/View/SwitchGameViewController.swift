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
    
    private var hStackView: UIStackView!
    private var vStackView: UIStackView!
    private var gridStackView: UIStackView!
    private var promptView: UIStackView!
    private var secondArrayStackView: UIStackView!
    private var gridButtons: [[UIButton]] = []
    
    private var notifyCoordinatorButton: UIButton!
    var colorArray = ["Red", "Blue", "Yellow", "Green"]
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
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = 10
        hStackView.distribution = .fill
        view.addSubview(hStackView)
        
        notifyCoordinatorButton = UIButton(type: .system)
        notifyCoordinatorButton.setTitle("Notify Coordinator", for: .normal)
        notifyCoordinatorButton.addTarget(self, action: #selector(didCompleteQuickTimeEvent), for: .touchUpInside)
        hStackView.addArrangedSubview(notifyCoordinatorButton)
        
        vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 10
        vStackView.distribution = .fill
        hStackView.addArrangedSubview(vStackView)
        
        hStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate([
            notifyCoordinatorButton.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.4),
            vStackView.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.6)
        ])
        
        promptView = UIStackView()
        promptView.axis = .horizontal
        promptView.spacing = 10
        promptView.distribution = .fillProportionally
        let promptText = UILabel()
        promptText.text = "Select the correct answer"
        let timeText = UILabel()
        timeText.text = "waktu tersisa :"
        promptView.addArrangedSubview(promptText)
        promptView.addArrangedSubview(timeText)
        vStackView.addArrangedSubview(promptView)
        
        setupGrid()
        vStackView.addArrangedSubview(gridStackView)
        
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            promptView.heightAnchor.constraint(equalTo: vStackView.heightAnchor, multiplier: 0.2),
            secondArrayStackView.heightAnchor.constraint(equalTo: vStackView.heightAnchor, multiplier: 0.2),
            gridStackView.heightAnchor.constraint(equalTo: vStackView.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupGrid() {
        firstArray.shuffle()
        secondArray.shuffle()
        
        secondArrayStackView = UIStackView()
        secondArrayStackView.axis = .horizontal
        secondArrayStackView.spacing = 10
        secondArrayStackView.distribution = .fillEqually
        vStackView.addArrangedSubview(secondArrayStackView)
        
        let indicatorView = UIView()
        let indicatorLabel = UILabel()
        indicatorLabel.text = "lampu"
        indicatorView.addSubview(indicatorLabel)
        
        secondArrayStackView.addArrangedSubview(indicatorView)

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
        vStackView.addArrangedSubview(gridStackView)

        for row in 0..<firstArray.count {
            let rowContainerStackView = UIStackView()
            rowContainerStackView.axis = .horizontal
            rowContainerStackView.spacing = 10
            rowContainerStackView.alignment = .center

            let labelBox = UIView()
            let label = UILabel()
            label.text = firstArray[row]
            label.textAlignment = .left
            label.adjustsFontSizeToFitWidth = true
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentHuggingPriority(.required, for: .horizontal)
            labelBox.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: labelBox.leadingAnchor),
                label.centerYAnchor.constraint(equalTo: labelBox.centerYAnchor)
            ])
            
            rowContainerStackView.addArrangedSubview(labelBox)

            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 8
            rowStackView.distribution = .fillEqually

            var rowButtons: [UIButton] = []
            for column in 0..<secondArray.count {
                let button = UIButton(type: .system)

                if let image = UIImage(named: "Switch Off")?.withRenderingMode(.alwaysOriginal) {
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
            labelBox.translatesAutoresizingMaskIntoConstraints = false
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                labelBox.widthAnchor.constraint(equalTo: rowContainerStackView.widthAnchor, multiplier: 0.2),
                rowStackView.widthAnchor.constraint(equalTo: rowContainerStackView.widthAnchor, multiplier: 0.8)
            ])
            gridStackView.addArrangedSubview(rowContainerStackView)
        }
    }

    @objc private func toggleButton(_ sender: UIButton) {
        viewModel.toggleButton(label: sender.accessibilityLabel ?? "")
        
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "Switch On")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "Switch Off")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        let text = "Task completed successfully."
        notifyCoordinatorButton.setTitle(text, for: .normal)
    }
    
    private func showErrorAlert() {
        let text = "Wrong Button Bruh."
        notifyCoordinatorButton.setTitle(text, for: .normal)
    }
}

