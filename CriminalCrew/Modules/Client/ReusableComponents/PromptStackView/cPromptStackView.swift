//
//  cPromptStackView.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 13/10/24.
//

import UIKit

internal class PromptStackView: UIStackView {
    
    internal var promptView: PromptView = PromptView(label: "Initial Prompt")
    internal var timeView: TimeView = TimeView()
    
    internal init() {
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(frame: .zero)
        setupStackView()
    }
    
    private func setupStackView() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 8
        
        addArrangedSubview(promptView)
        addArrangedSubview(timeView)
        
        promptView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            promptView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            timeView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
        ])
    }
    
}
