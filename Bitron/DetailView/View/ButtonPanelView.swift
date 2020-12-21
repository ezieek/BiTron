//
//  ButtonPanelView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 12/17/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class ButtonPanelView: UIView {
    
    // MARK: - Properties
    lazy var selectedTimeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("D", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var oneYearButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Y", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var oneMonthButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("M", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.backgroundColor = .red
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = "month"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var oneWeekButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("W", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.backgroundColor = .red
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = "week"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var oneDayButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("D", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var oneHourButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("1h", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var thirtyMinutesButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("30m", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var fifteenMinutesButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("15m", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var oneMinuteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("1m", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = true
        button.backgroundColor = .red
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = "one"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var expandedStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [oneMinuteButton, fifteenMinutesButton, thirtyMinutesButton, oneHourButton, oneDayButton, oneWeekButton, oneMonthButton, oneYearButton])
        stackView.axis = .vertical
        stackView.isHidden = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [selectedTimeButton, expandedStackView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - init - deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        [containerStackView].forEach { addSubview($0) }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectedTimeButton.widthAnchor.constraint(equalToConstant: 50),
            selectedTimeButton.heightAnchor.constraint(equalToConstant: 50),
            oneYearButton.widthAnchor.constraint(equalToConstant: 50),
            oneYearButton.heightAnchor.constraint(equalToConstant: 50),
            oneMonthButton.widthAnchor.constraint(equalToConstant: 50),
            oneMonthButton.heightAnchor.constraint(equalToConstant: 50),
            oneWeekButton.widthAnchor.constraint(equalToConstant: 50),
            oneWeekButton.heightAnchor.constraint(equalToConstant: 50),
            oneDayButton.widthAnchor.constraint(equalToConstant: 50),
            oneDayButton.heightAnchor.constraint(equalToConstant: 50),
            oneHourButton.widthAnchor.constraint(equalToConstant: 50),
            oneHourButton.heightAnchor.constraint(equalToConstant: 50),
            thirtyMinutesButton.widthAnchor.constraint(equalToConstant: 50),
            thirtyMinutesButton.heightAnchor.constraint(equalToConstant: 50),
            fifteenMinutesButton.widthAnchor.constraint(equalToConstant: 50),
            fifteenMinutesButton.heightAnchor.constraint(equalToConstant: 50),
            oneMinuteButton.widthAnchor.constraint(equalToConstant: 50),
            oneMinuteButton.heightAnchor.constraint(equalToConstant: 50),
            self.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            self.heightAnchor.constraint(equalTo: containerStackView.heightAnchor)
        ])
    }
}
