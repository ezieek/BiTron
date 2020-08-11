//
//  DetailView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class DetailView: UIView {

    let screen = UIScreen.main.bounds
    
    lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pushNotificationButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.setTitle("Push Notifications Enabled", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        [rateLabel, pushNotificationButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            rateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            pushNotificationButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: screen.height * 0.8),
            pushNotificationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            pushNotificationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            pushNotificationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
    }
}
