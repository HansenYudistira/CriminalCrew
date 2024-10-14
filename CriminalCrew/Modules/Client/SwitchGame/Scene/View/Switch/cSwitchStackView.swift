//
//  cSwitchView.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 13/10/24.
//

import UIKit

internal class SwitchStackView: UIStackView {
    
    weak var delegate: ButtonTappedDelegate?
    
    internal var correctIndicatorView: SwitchIndicatorView = SwitchIndicatorView(imageName: "Green Light Off")
    internal var falseIndicatorView: SwitchIndicatorView = SwitchIndicatorView(imageName: "Red Light Off")
    
    private var firstArray : [String] = ["Quantum", "Pseudo"]
    private var secondArray : [String] = ["Encryption", "AIIDS", "Cryptography", "Protocol"]
    
    init() {
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        axis = .vertical
        spacing = 8
        
        firstArray.shuffle()
        secondArray.shuffle()
        
        let indicatorStackView = ViewFactory.createHorizontalStackView()
        
        indicatorStackView.addArrangedSubview(correctIndicatorView)
        indicatorStackView.addArrangedSubview(falseIndicatorView)
        
        let secondArrayStackView = ViewFactory.createHorizontalStackView()
        secondArrayStackView.addArrangedSubview(indicatorStackView)
        
        addArrangedSubview(secondArrayStackView)

        for column in 0..<secondArray.count {
            let labelView = LabelView(text: secondArray[column])
            secondArrayStackView.addArrangedSubview(labelView)
        }
        
        let gridStackView = ViewFactory.createVerticalStackView()

        for row in 0..<firstArray.count {
            let rowContainerStackView = ViewFactory.createHorizontalStackView()

            let labelView = LabelView(text: firstArray[row])
            
            rowContainerStackView.addArrangedSubview(labelView)

            let switchStackView = ViewFactory.createHorizontalStackView()

            for column in 0..<secondArray.count {
                let button = SwitchButton(firstLabel: firstArray[row], secondLabel: secondArray[column])
                button.addTarget(self, action: #selector(switchTapped(_:)), for: .touchUpInside)

                switchStackView.addArrangedSubview(button)
            }
            
            rowContainerStackView.addArrangedSubview(switchStackView)
            
            NSLayoutConstraint.activate([
                labelView.widthAnchor.constraint(equalTo: rowContainerStackView.widthAnchor, multiplier: 0.2),
                switchStackView.widthAnchor.constraint(equalTo: rowContainerStackView.widthAnchor, multiplier: 0.8)
            ])
            gridStackView.addArrangedSubview(rowContainerStackView)
        }
        
        addArrangedSubview(gridStackView)
        
        NSLayoutConstraint.activate([
            secondArrayStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            gridStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
    }
    
    @objc private func switchTapped(_ sender: SwitchButton) {
        delegate?.buttonTapped(sender: sender)
    }
    
}
