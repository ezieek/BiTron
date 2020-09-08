//
//  LoginView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/8/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitron"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        
        [appNameLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            appNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

    }
}
