//
//  LoginView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/8/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    // MARK: - Properties
    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitron"
        label.font = .systemFont(ofSize: 30)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var newAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("New Account? Sign Up!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - init - deinit
    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal
    func createSubViews() {
        
        [appNameLabel, emailLabel, emailTextField, passwordLabel, passwordTextField, signInButton, newAccountButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            appNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -250),
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            emailTextField.topAnchor.constraint(equalTo: topAnchor, constant: 250),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
           /* emailLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            emailLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),*/
        ])
    }
}
