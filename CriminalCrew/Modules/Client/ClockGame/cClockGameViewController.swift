//
//  ClockGameViewController.swift
//  CriminalCrew
//
//  Created by Hansen Yudistira on 14/10/24.
//

import UIKit

internal class ClockGameViewController: BaseGameViewController, GameContentProvider {
    internal var viewModel: SwitchGameViewModel?
    internal var coordinator: RootCoordinator?
    
    var switchStackView: SwitchStackView?
    
    var clockFace: UIView = UIView()
    var shortHand: UIView = UIView()
    var longHand: UIView = UIView()
    
    let totalSymbols = 12
    var symbols: [UIView] = []
    let symbolsSwitch: [String] = ["Æ", "Ë", "ß", "æ", "Ø", "ɧ", "ɶ", "Σ", "Φ", "Ψ", "Ω", "Ђ", "б", "Ӭ"]

    func createFirstPanelView() -> UIView {
        
        let firstPanelContainerView = UIView()
        
        let portraitBackgroundImage = ViewFactory.addBackgroundImageView("BG Portrait")
        firstPanelContainerView.addSubview(portraitBackgroundImage)
        NSLayoutConstraint.activate([
            portraitBackgroundImage.topAnchor.constraint(equalTo: firstPanelContainerView.topAnchor),
            portraitBackgroundImage.leadingAnchor.constraint(equalTo: firstPanelContainerView.leadingAnchor),
            portraitBackgroundImage.bottomAnchor.constraint(equalTo: firstPanelContainerView.bottomAnchor),
            portraitBackgroundImage.trailingAnchor.constraint(equalTo: firstPanelContainerView.trailingAnchor)
        ])
        
        setupClockFace()
        setupHands()
        
        firstPanelContainerView.addSubview(clockFace)
        
        clockFace.addSubview(longHand)
        clockFace.addSubview(shortHand)
        NSLayoutConstraint.activate([
            shortHand.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor),
            shortHand.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor),
            shortHand.widthAnchor.constraint(equalTo: clockFace.widthAnchor, multiplier: 0.12),
            shortHand.heightAnchor.constraint(equalTo: clockFace.heightAnchor, multiplier: 0.15),
            longHand.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor),
            longHand.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor),
            longHand.widthAnchor.constraint(equalTo: clockFace.widthAnchor, multiplier: 0.12),
            longHand.heightAnchor.constraint(equalTo: clockFace.heightAnchor, multiplier: 0.25),
            clockFace.topAnchor.constraint(equalTo: firstPanelContainerView.topAnchor, constant: 16),
            clockFace.leadingAnchor.constraint(equalTo: firstPanelContainerView.leadingAnchor, constant: 16),
            clockFace.trailingAnchor.constraint(equalTo: firstPanelContainerView.trailingAnchor, constant: -16),
            clockFace.bottomAnchor.constraint(equalTo: firstPanelContainerView.bottomAnchor, constant: -16)
        ])
        
        let radius: CGFloat = clockFace.frame.width / 7
        let symbolTexts = generateRandomSymbols()
        
        for i in 0..<totalSymbols {
            let angle = CGFloat(i) * (2 * .pi / CGFloat(totalSymbols)) - .pi / 2
            let x = cos(angle) * radius
            let y = sin(angle) * radius
            
            let labelBox = UIView()
            let label = UILabel()
            label.text = symbolTexts[i]
            label.font = UIFont.systemFont(ofSize: 30)
            label.sizeToFit()
            label.center = CGPoint(x: x, y: y)
            
            labelBox.addSubview(label)
            labelBox.translatesAutoresizingMaskIntoConstraints = false
            clockFace.addSubview(labelBox)
            
            NSLayoutConstraint.activate([
                labelBox.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor),
                labelBox.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor)
            ])
            symbols.append(labelBox)
        }
        
        firstPanelContainerView.addSubview(clockFace)
        clockFace.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clockFace.topAnchor.constraint(equalTo: firstPanelContainerView.topAnchor, constant: 16),
            clockFace.leadingAnchor.constraint(equalTo: firstPanelContainerView.leadingAnchor, constant: 16),
            clockFace.trailingAnchor.constraint(equalTo: firstPanelContainerView.trailingAnchor, constant: -16),
            clockFace.bottomAnchor.constraint(equalTo: firstPanelContainerView.bottomAnchor, constant: -16)
        ])
        
        return firstPanelContainerView
    }
    
    func createSecondPanelView() -> UIView {
        let secondPanelContainerView: UIView = UIView()
        
        let landscapeBackgroundImage = ViewFactory.addBackgroundImageView("BG Landscape")
        secondPanelContainerView.addSubview(landscapeBackgroundImage)
        
        switchStackView = SwitchStackView()
        
        if let switchStackView = switchStackView {
            switchStackView.translatesAutoresizingMaskIntoConstraints = false
            switchStackView.delegate = self
            secondPanelContainerView.addSubview(switchStackView)
            
            NSLayoutConstraint.activate([
                switchStackView.topAnchor.constraint(equalTo: secondPanelContainerView.topAnchor, constant: 16),
                switchStackView.leadingAnchor.constraint(equalTo: secondPanelContainerView.leadingAnchor, constant: 16),
                switchStackView.trailingAnchor.constraint(equalTo: secondPanelContainerView.trailingAnchor, constant: -16),
                switchStackView.bottomAnchor.constraint(equalTo: secondPanelContainerView.bottomAnchor, constant: -16)
            ])
        }
        
        NSLayoutConstraint.activate([
            landscapeBackgroundImage.topAnchor.constraint(equalTo: secondPanelContainerView.topAnchor),
            landscapeBackgroundImage.leadingAnchor.constraint(equalTo: secondPanelContainerView.leadingAnchor),
            landscapeBackgroundImage.trailingAnchor.constraint(equalTo: secondPanelContainerView.trailingAnchor),
            landscapeBackgroundImage.bottomAnchor.constraint(equalTo: secondPanelContainerView.bottomAnchor)
        ])
        
        return secondPanelContainerView
    }
    
    override func setupGameContent() {
        contentProvider = self
    }
    
    func setupClockFace() {
        let clockFaceImage = UIImage(named: "Clock")
        clockFace = UIImageView(image: clockFaceImage)
        clockFace.contentMode = .scaleAspectFit
        clockFace.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupHands() {
        shortHand = createHand(imageName: "Short Arrow", size: CGSize(width: 30, height: 55), anchorPoint: CGPoint(x: 0.5, y: 1))
        longHand = createHand(imageName: "Long Arrow", size: CGSize(width: 33, height: 90), anchorPoint: CGPoint(x: 0.5, y: 1))
    }
    
    func createHand(imageName: String, size: CGSize, anchorPoint: CGPoint) -> UIView {
        let hand = UIImageView(image: UIImage(named: imageName))
        hand.frame = CGRect(origin: .zero, size: size)
        hand.layer.anchorPoint = anchorPoint
        hand.translatesAutoresizingMaskIntoConstraints = false
        return hand
    }
    
    func generateRandomSymbols() -> [String] {
        return symbolsSwitch.shuffled()
    }

}

extension ClockGameViewController: ButtonTappedDelegate {
    internal func buttonTapped(sender: UIButton) {
        if let sender = sender as? LeverButton {
            if let label = sender.accessibilityLabel {
                print(label)
            }
            sender.toggleButtonState()
        } else if let sender = sender as? SwitchButton {
            if let label = sender.accessibilityLabel {
                print(label)
            }
            sender.toggleButtonState()
        }
        
    }

}
