//
//  SwitchGameViewController.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 27/09/24.
//

import UIKit
import Combine

internal class SwitchGameViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: SwitchGameViewModel!
    var coordinator: RootCoordinator?
    
    private var leverStackView: UIStackView!
    private var hStackView: UIStackView!
    private var vStackView: UIStackView!
    private var gridStackView: UIStackView!
    private var promptView: UIStackView!
    private var secondArrayStackView: UIStackView!
    private var indicatorStackView: UIStackView!
    private var gridButtons: [[UIButton]] = []
    
    private var notifyCoordinatorButton: UIButton!
    var colorArray = ["Red", "Blue", "Yellow", "Green"]
    var firstArray = ["Quantum", "Pseudo"]
    var secondArray = ["Encryption", "AIIDS", "Cryptography", "Protocol"]
    
    private let didPressedButton = PassthroughSubject<String, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        forceLandscapeOrientation()
        
        let repository = MultipeerTaskRepository()
        let useCase = SwitchGameUseCase(taskRepository: repository)
        self.viewModel = SwitchGameViewModel(switchGameUseCase: useCase)
        
        setupUI()
        bindViewModel()
    }
    
    private func forceLandscapeOrientation() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
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
        
        leverStackView = UIStackView()
        leverStackView.axis = .vertical
        leverStackView.spacing = 10
        leverStackView.distribution = .fill
        hStackView.addArrangedSubview(leverStackView)
        
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.addArrangedSubview(spacerView)
        
        notifyCoordinatorButton = UIButton(type: .system)
        notifyCoordinatorButton.setTitle("Notify Coordinator", for: .normal)
        notifyCoordinatorButton.addTarget(self, action: #selector(didCompleteQuickTimeEvent), for: .touchUpInside)
        leverStackView.addArrangedSubview(notifyCoordinatorButton)
        let portraitBackgroundImage = UIImageView()
        portraitBackgroundImage.image = UIImage(named: "BG Portrait")
        portraitBackgroundImage.contentMode = .scaleAspectFill
        portraitBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(portraitBackgroundImage, belowSubview: hStackView)
        
        vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.spacing = 10
        vStackView.distribution = .fill
        hStackView.addArrangedSubview(vStackView)
        
        hStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate([
            portraitBackgroundImage.topAnchor.constraint(equalTo: leverStackView.topAnchor),
            portraitBackgroundImage.leadingAnchor.constraint(equalTo: leverStackView.leadingAnchor),
            portraitBackgroundImage.bottomAnchor.constraint(equalTo: leverStackView.bottomAnchor),
            portraitBackgroundImage.trailingAnchor.constraint(equalTo: leverStackView.trailingAnchor),
            leverStackView.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.375),
            spacerView.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.05),
            vStackView.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.575)
        ])
        
        promptView = UIStackView()
        promptView.axis = .horizontal
        promptView.spacing = 10
        promptView.distribution = .fillProportionally
        let promptText = UILabel()
        promptText.text = "Select the correct answer :"
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
        
        indicatorStackView = UIStackView()
        indicatorStackView.axis = .horizontal
        indicatorStackView.spacing = 10
        indicatorStackView.distribution = .fillEqually
        
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
                let button = SwitchButton(firstLabel: firstArray[row], secondLabel: secondArray[column])

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
    
    private func bindViewModel() {
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
    
    private func updateButtonAppearance(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "Switch On")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "Switch Off")?.withRenderingMode(.alwaysOriginal), for: .normal)
            sender.tag = 0
        }
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
                        
    private func changeTimeLabelText(text: String) {
        if let timeLabel = promptView.arrangedSubviews[1] as? UILabel {
            timeLabel.text = text
        }
    }
}

