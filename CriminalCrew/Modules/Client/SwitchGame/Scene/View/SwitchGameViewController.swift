//
//  SwitchGameViewController.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import UIKit
import Combine

internal class SwitchGameViewController: BaseGameViewController, GameContentProvider {
    
    private var cancellables = Set<AnyCancellable>()
    internal var viewModel: SwitchGameViewModel?
    internal var coordinator: RootCoordinator?
    
    private let leverStackView: UIStackView = createVerticalStackView()
    private let leverIndicatorStackView: UIStackView = createHorizontalStackView()
    
    private let gridStackView: UIStackView = createVerticalStackView()
    private let switchContainerStackView: UIStackView = createVerticalStackView()
    private let secondArrayStackView: UIStackView = createHorizontalStackView()
    private let indicatorStackView: UIStackView = createHorizontalStackView()
    
    private let promptStackView: UIStackView = createHorizontalStackView()
    private var promptView: PromptView?
    private var timeView: TimeView?
    
    private var notifyCoordinatorButton: UIButton = UIButton(type: .system)
    private var colorArray : [String] = ["Red", "Blue", "Yellow", "Green"]
    private var firstArray : [String] = ["Quantum", "Pseudo"]
    private var secondArray : [String] = ["Encryption", "AIIDS", "Cryptography", "Protocol"]
    
    private let didPressedButton = PassthroughSubject<String, Never>()
    
    internal func createFirstPanelView() -> UIView {
        let firstPanelContainerView = UIView()
        firstPanelContainerView.translatesAutoresizingMaskIntoConstraints = false
        firstPanelContainerView.addSubview(leverStackView)
        leverStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leverStackView.topAnchor.constraint(equalTo: firstPanelContainerView.topAnchor, constant: 16),
            leverStackView.leadingAnchor.constraint(equalTo: firstPanelContainerView.leadingAnchor, constant: 16),
            leverStackView.trailingAnchor.constraint(equalTo: firstPanelContainerView.trailingAnchor, constant: -16),
            leverStackView.bottomAnchor.constraint(equalTo: firstPanelContainerView.bottomAnchor, constant: -16)
        ])
        
        setupLeverViewContent()
        
        let portraitBackgroundImage = addBackgroundImageView("BG Portrait")
        
        firstPanelContainerView.insertSubview(portraitBackgroundImage, at: 0)
        
        NSLayoutConstraint.activate([
            portraitBackgroundImage.topAnchor.constraint(equalTo: firstPanelContainerView.topAnchor),
            portraitBackgroundImage.leadingAnchor.constraint(equalTo: firstPanelContainerView.leadingAnchor),
            portraitBackgroundImage.bottomAnchor.constraint(equalTo: firstPanelContainerView.bottomAnchor),
            portraitBackgroundImage.trailingAnchor.constraint(equalTo: firstPanelContainerView.trailingAnchor)
        ])
        
        return firstPanelContainerView
    }
    
    internal func createSecondPanelView() -> UIView {
        let secondPanelContainerView = UIView()
        secondPanelContainerView.translatesAutoresizingMaskIntoConstraints = false
        secondPanelContainerView.addSubview(switchContainerStackView)
        
        switchContainerStackView.addArrangedSubview(secondArrayStackView)
        switchContainerStackView.addArrangedSubview(gridStackView)
        switchContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            switchContainerStackView.topAnchor.constraint(equalTo: secondPanelContainerView.topAnchor, constant: 16),
            switchContainerStackView.leadingAnchor.constraint(equalTo: secondPanelContainerView.leadingAnchor, constant: 16),
            switchContainerStackView.trailingAnchor.constraint(equalTo: secondPanelContainerView.trailingAnchor, constant: -16),
            switchContainerStackView.bottomAnchor.constraint(equalTo: secondPanelContainerView.bottomAnchor, constant: -16),
            secondArrayStackView.heightAnchor.constraint(equalTo: switchContainerStackView.heightAnchor, multiplier: 0.2),
            gridStackView.heightAnchor.constraint(equalTo: switchContainerStackView.heightAnchor, multiplier: 0.8)
        ])
        setupSwitchViewContent()
        
        let landscapeBackgroundImage = addBackgroundImageView("BG Landscape")
        
        secondPanelContainerView.insertSubview(landscapeBackgroundImage, at: 0)
        
        NSLayoutConstraint.activate([
            landscapeBackgroundImage.topAnchor.constraint(equalTo: secondPanelContainerView.topAnchor),
            landscapeBackgroundImage.leadingAnchor.constraint(equalTo: secondPanelContainerView.leadingAnchor),
            landscapeBackgroundImage.trailingAnchor.constraint(equalTo: secondPanelContainerView.trailingAnchor),
            landscapeBackgroundImage.bottomAnchor.constraint(equalTo: secondPanelContainerView.bottomAnchor)
        ])
        
        return secondPanelContainerView
    }
    
    internal func createPromptView() -> UIView {
        promptView = PromptView(label: "Initial Task")
        timeView = TimeView()
        
        if let promptView = promptView, let timeView = timeView {
            promptView.translatesAutoresizingMaskIntoConstraints = false
            promptStackView.addArrangedSubview(promptView)
            promptStackView.addArrangedSubview(timeView)
            NSLayoutConstraint.activate([
                promptView.widthAnchor.constraint(equalTo: promptStackView.widthAnchor, multiplier: 0.9),
                timeView.widthAnchor.constraint(equalTo: promptStackView.widthAnchor, multiplier: 0.1),
            ])
            
            return promptStackView
        }
        
        return UIView()
    }
    
    private func setupLeverViewContent() {
        notifyCoordinatorButton.setTitle("Notify Coordinator", for: .normal)
        notifyCoordinatorButton.addTarget(self, action: #selector(didCompleteQuickTimeEvent), for: .touchUpInside)
        leverStackView.addArrangedSubview(leverIndicatorStackView)
        leverStackView.addArrangedSubview(notifyCoordinatorButton)
    }
    
    private func setupSwitchViewContent() {
        firstArray.shuffle()
        secondArray.shuffle()
        
        let rightIndicatorView = UIImageView()
        rightIndicatorView.contentMode = .scaleAspectFit
        rightIndicatorView.image = UIImage(named: "Green Light Off")
        let falseIndicatorView = UIImageView()
        falseIndicatorView.contentMode = .scaleAspectFit
        falseIndicatorView.image = UIImage(named: "Red Light Off")
        
        indicatorStackView.addArrangedSubview(rightIndicatorView)
        indicatorStackView.addArrangedSubview(falseIndicatorView)
        
        secondArrayStackView.addArrangedSubview(indicatorStackView)

        for column in 0..<secondArray.count {
            let label = SwitchGameViewController.createLabel(text: secondArray[column])
            secondArrayStackView.addArrangedSubview(label)
        }

        for row in 0..<firstArray.count {
            let rowContainerStackView = UIStackView()
            rowContainerStackView.axis = .horizontal
            rowContainerStackView.spacing = 8
            rowContainerStackView.alignment = .center

            let labelBox = UIView()
            let label = SwitchGameViewController.createLabel(text: firstArray[row])
            label.adjustsFontSizeToFitWidth = true
            labelBox.addSubview(label)
            
            rowContainerStackView.addArrangedSubview(labelBox)

            let switchStackView = SwitchGameViewController.createHorizontalStackView()

            for column in 0..<secondArray.count {
                let button = SwitchButton(firstLabel: firstArray[row], secondLabel: secondArray[column])

                button.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)

                switchStackView.addArrangedSubview(button)
            }
            
            rowContainerStackView.addArrangedSubview(switchStackView)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: labelBox.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: labelBox.trailingAnchor),
                label.topAnchor.constraint(equalTo: labelBox.topAnchor),
                label.bottomAnchor.constraint(equalTo: labelBox.bottomAnchor)
            ])
            
            NSLayoutConstraint.activate([
                labelBox.widthAnchor.constraint(equalTo: rowContainerStackView.widthAnchor, multiplier: 0.2),
                switchStackView.widthAnchor.constraint(equalTo: rowContainerStackView.widthAnchor, multiplier: 0.8)
            ])
            gridStackView.addArrangedSubview(rowContainerStackView)
        }
    }
    
    override func setupGameContent() {
        contentProvider = self
        
        let repository = MultipeerTaskRepository()
        let useCase = SwitchGameUseCase(taskRepository: repository)
        self.viewModel = SwitchGameViewModel(switchGameUseCase: useCase)
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        let input = SwitchGameViewModel.Input(didPressedButton: didPressedButton)
        viewModel.bind(input)
        
        viewModel.taskCompletionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccess in
                self?.showTaskAlert(isSuccess: isSuccess)
            }
            .store(in: &cancellables)
    }
    
    @objc private func toggleButton(_ sender: SwitchButton) {
        didPressedButton.send((sender.accessibilityLabel!))
        sender.toggleState()
    }
    
    @objc private func didCompleteQuickTimeEvent() {
        coordinator?.handleTaskCompletion()
    }

    private func showTaskAlert(isSuccess: Bool) {
        if let indicatorStackView = secondArrayStackView.arrangedSubviews.compactMap({ $0 as? UIStackView }).first {
            if isSuccess {
                if let rightIndicatorView = indicatorStackView.arrangedSubviews[0] as? UIImageView {
                    rightIndicatorView.image = UIImage(named: "Green Light On")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        rightIndicatorView.image = UIImage(named: "Green Light Off")
                    }
                }
            } else {
                if let falseIndicatorView = indicatorStackView.arrangedSubviews[1] as? UIImageView {
                    falseIndicatorView.image = UIImage(named: "Red Light On")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        falseIndicatorView.image = UIImage(named: "Red Light Off")
                    }
                }
            }
        }
    }
    
}

