//
//  cLeverView.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 13/10/24.
//

import UIKit

internal class LeverView: UIView {
    
    internal var leverIndicatorView: [LeverIndicatorView] = []
    internal var leverPanelView: LeverPanelView?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let verticalStackView = UIViewController.createVerticalStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let indicatorArray: [String] = ["Green Bulb Off", "Yellow Bulb Off", "Blue Bulb Off", "Red Bulb Off"]
        let indicatorStackView = UIViewController.createHorizontalStackView()
        indicatorStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for indicator in indicatorArray {
            let leverIndicator = LeverIndicatorView(imageName: indicator)
            leverIndicatorView.append(leverIndicator)
        }
        
        for leverIndicator in leverIndicatorView {
            indicatorStackView.addArrangedSubview(leverIndicator)
        }
        
        verticalStackView.addArrangedSubview(indicatorStackView)
        indicatorStackView.heightAnchor.constraint(equalTo: verticalStackView.heightAnchor, multiplier: 0.2).isActive = true
        
        leverPanelView = LeverPanelView()
        if let leverPanelView = leverPanelView {
            leverPanelView.translatesAutoresizingMaskIntoConstraints = false
            verticalStackView.addArrangedSubview(leverPanelView)
            
            leverPanelView.heightAnchor.constraint(equalTo: verticalStackView.heightAnchor, multiplier: 0.8).isActive = true
        }
        
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
