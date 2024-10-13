//
//  cPromptView.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 13/10/24.
//

import UIKit

internal class PromptView: UIView {
    
    internal var promptLabel: UILabel = UILabel()
    
    init(label: String) {
        super.init(frame: .zero)
        setupView(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(_ label: String) {
        let promptBackground = UIImageView(image: UIImage(named: "Prompt"))
        promptBackground.contentMode = .scaleToFill
        promptBackground.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.text = label
        promptLabel.numberOfLines = 0
        promptLabel.textAlignment = .center
        promptLabel.font = UIFont(name: "GothamSSm", size: 17)
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(promptBackground)
        addSubview(promptLabel)
        
        NSLayoutConstraint.activate([
            promptBackground.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            promptBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            promptBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            promptBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            promptLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            promptLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
