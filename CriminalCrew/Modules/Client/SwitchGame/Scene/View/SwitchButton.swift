//
//  SwitchButton.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 09/10/24.
//

import UIKit

class SwitchButton: UIButton {
    init(firstLabel: String, secondLabel: String) {
        super.init(frame: .zero)
        setupButton(firstLabel, secondLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(_ firstLabel: String, _ secondLabel: String) {
        if let image = UIImage(named: "Switch Off")?.withRenderingMode(.alwaysOriginal) {
            self.setImage(image, for: .normal)
        }
        
        self.imageView?.contentMode = .scaleAspectFit
        self.backgroundColor = .clear
        self.accessibilityLabel = "\(firstLabel) \(secondLabel)"
        self.tag = 0
    }
    
    func toggleState() {
        if tag == 0 {
            setImage(UIImage(named: "Switch On")?.withRenderingMode(.alwaysOriginal), for: .normal)
            tag = 1
        } else {
            setImage(UIImage(named: "Switch Off")?.withRenderingMode(.alwaysOriginal), for: .normal)
            tag = 0
        }
    }
}
