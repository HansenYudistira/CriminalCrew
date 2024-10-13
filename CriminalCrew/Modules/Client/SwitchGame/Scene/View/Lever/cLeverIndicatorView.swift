//
//  LeverIndicatorView.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 11/10/24.
//

import UIKit

internal class LeverIndicatorView: UIImageView {
    
    internal var bulbColor: String
    internal var isOn: Bool = false
    
    init(imageName: String) {
        self.bulbColor = imageName.components(separatedBy: " ")[0]
        super.init(frame: .zero)
        setupImageView(imageName: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(imageName: String) {
        image = UIImage(named: imageName)
        contentMode = .scaleAspectFit
    }
    
    internal func toggleState() {
        isOn.toggle()
        
        let newImageName = "\(bulbColor) Bulb \(isOn ? "On" : "Off")"
        image = UIImage(named: newImageName)
    }
    
}
