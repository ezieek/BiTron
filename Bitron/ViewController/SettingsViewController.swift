//
//  SettingsViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 11/6/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: SettingsCoordinator?
    private lazy var settingBackgroundColor = Colors()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - private
    private func setupView() {
        navigationItem.title = "Bitron"
        navigationItem.setHidesBackButton(true, animated: true)
        view.layer.insertSublayer(settingBackgroundColor.gradientColor, at: 0)
    }
}
