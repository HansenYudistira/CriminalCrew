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
    
    var viewModel: SwitchGameViewModel?
    var coordinator: RootCoordinator?
    
    private var leverStackView: UIStackView = UIStackView()
    private var hStackView: UIStackView = UIStackView()
    private var vStackView: UIStackView = UIStackView()
    private var gridStackView: UIStackView = UIStackView()
    private var secondArrayStackView: UIStackView = UIStackView()
    private var indicatorStackView: UIStackView = UIStackView()
    
    private var timeLabel: UILabel = UILabel()
    private var promptLabel: UILabel = UILabel()
    private var promptBackground: UIImageView = UIImageView()
    private var promptContainerView: UIView = UIView()
    private var promptStackView: UIStackView = UIStackView()
    
    private var notifyCoordinatorButton: UIButton = UIButton(type: .system)
    var colorArray : [String] = ["Red", "Blue", "Yellow", "Green"]
    var firstArray : [String] = ["Quantum", "Pseudo"]
    var secondArray : [String] = ["Encryption", "AIIDS", "Cryptography", "Protocol"]
    
    private let didPressedButton = PassthroughSubject<String, Never>()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forceLandscapeOrientation()
        
        let repository = MultipeerTaskRepository()
        let useCase = SwitchGameUseCase(taskRepository: repository)
        self.viewModel = SwitchGameViewModel(switchGameUseCase: useCase)
        
        setupUI()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("promptStackView frame: \(promptStackView.frame)")
        print("promptContainerView frame: \(promptContainerView.frame)")
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
        
        hStackView.axis = .horizontal
        hStackView.spacing = 10
        hStackView.distribution = .fill
        view.addSubview(hStackView)
        
        leverStackView.axis = .vertical
        leverStackView.spacing = 10
        leverStackView.distribution = .fill
        hStackView.addArrangedSubview(leverStackView)
        
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.addArrangedSubview(spacerView)
        
        notifyCoordinatorButton.setTitle("Notify Coordinator", for: .normal)
        notifyCoordinatorButton.addTarget(self, action: #selector(didCompleteQuickTimeEvent), for: .touchUpInside)
        leverStackView.addArrangedSubview(notifyCoordinatorButton)
        
        let portraitBackgroundImage = UIImageView()
        portraitBackgroundImage.image = UIImage(named: "BG Portrait")
        portraitBackgroundImage.contentMode = .scaleAspectFill
        portraitBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(portraitBackgroundImage, belowSubview: hStackView)
        
        let landscapeBackgroundImage = UIImageView()
        landscapeBackgroundImage.image = UIImage(named: "BG Landscape")
        landscapeBackgroundImage.contentMode = .scaleAspectFill
        landscapeBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(landscapeBackgroundImage, belowSubview: hStackView)
        
        vStackView.axis = .vertical
        vStackView.spacing = 10
        vStackView.distribution = .fill
        hStackView.addArrangedSubview(vStackView)
        
        hStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        NSLayoutConstraint.activate([
            portraitBackgroundImage.topAnchor.constraint(equalTo: leverStackView.topAnchor),
            portraitBackgroundImage.leadingAnchor.constraint(equalTo: leverStackView.leadingAnchor, constant: 8),
            portraitBackgroundImage.bottomAnchor.constraint(equalTo: leverStackView.bottomAnchor),
            portraitBackgroundImage.trailingAnchor.constraint(equalTo: leverStackView.trailingAnchor, constant: -8),
            leverStackView.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.375),
            spacerView.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.05),
            vStackView.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.575)
        ])
        
        setupPromptView()
        setupPromptViewConstraint()
        
        setupGrid()
        vStackView.addArrangedSubview(gridStackView)
        
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            landscapeBackgroundImage.topAnchor.constraint(equalTo: secondArrayStackView.topAnchor, constant: 8),
            landscapeBackgroundImage.leadingAnchor.constraint(equalTo: secondArrayStackView.leadingAnchor, constant: 8),
            landscapeBackgroundImage.trailingAnchor.constraint(equalTo: secondArrayStackView.trailingAnchor, constant: -8),
            landscapeBackgroundImage.bottomAnchor.constraint(equalTo: gridStackView.bottomAnchor),
            promptStackView.heightAnchor.constraint(equalTo: vStackView.heightAnchor, multiplier: 0.2),
            secondArrayStackView.heightAnchor.constraint(equalTo: vStackView.heightAnchor, multiplier: 0.2),
            gridStackView.heightAnchor.constraint(equalTo: vStackView.heightAnchor, multiplier: 0.6)
        ])
        
    }
    
    private func setupPromptView() {
        promptStackView.axis = .horizontal
        promptStackView.spacing = 10
        promptStackView.distribution = .fill
        
        promptBackground = UIImageView(image: UIImage(named: "Prompt"))
        promptBackground.contentMode = .scaleAspectFill
        
        promptLabel.text = "Quantum Encryption, Pseudo AIIDS"
        promptLabel.textAlignment = .center
        promptContainerView.addSubview(promptBackground)
        promptContainerView.addSubview(promptLabel)
        
        timeLabel = UILabel()
        timeLabel.text = "20 detik"
        
        promptStackView.addArrangedSubview(promptContainerView)
        promptStackView.addArrangedSubview(timeLabel)
        vStackView.addArrangedSubview(promptStackView)
    }
    
    private func setupPromptViewConstraint() {
        promptBackground.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            promptContainerView.widthAnchor.constraint(equalTo: promptStackView.widthAnchor, multiplier: 0.8),
            timeLabel.widthAnchor.constraint(equalTo: promptStackView.widthAnchor, multiplier: 0.2),
            
            promptBackground.topAnchor.constraint(equalTo: promptContainerView.topAnchor, constant: 8),
            promptBackground.leadingAnchor.constraint(equalTo: promptContainerView.leadingAnchor, constant: 8),
            promptBackground.trailingAnchor.constraint(equalTo: promptContainerView.trailingAnchor, constant: -8),
            promptBackground.bottomAnchor.constraint(equalTo: promptContainerView.bottomAnchor, constant: -8),
            
            promptLabel.centerXAnchor.constraint(equalTo: promptContainerView.centerXAnchor),
            promptLabel.centerYAnchor.constraint(equalTo: promptContainerView.centerYAnchor)
        ])
    }
    
    private func setupGrid() {
        firstArray.shuffle()
        secondArray.shuffle()
        
        secondArrayStackView.axis = .horizontal
        secondArrayStackView.spacing = 10
        secondArrayStackView.distribution = .fillEqually
        vStackView.addArrangedSubview(secondArrayStackView)
        
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

            for column in 0..<secondArray.count {
                let button = SwitchButton(firstLabel: firstArray[row], secondLabel: secondArray[column])

                button.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)

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

