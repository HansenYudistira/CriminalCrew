//
//  cTimeView.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 13/10/24.
//

import UIKit

internal class TimeView: UIImageView {
    
    init () {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView () {
        let timeImage = UIImage(named: "Timer")
        self.image = timeImage
        self.contentMode = .scaleToFill
        
    }
    
}
