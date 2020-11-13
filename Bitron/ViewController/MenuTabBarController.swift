//
//  MenuTabBarController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 11/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class MenuTabBarController: UITabBarController {

    // MARK: - Properties
    let chosenCryptocurrency = ChosenCryptocurrencyCoordinator()
    let selectCryptocurrency = SelectCryptocurrencyCoordinator()
    let detailCryptocurrency = DetailCryptocurrencyCoordinator()
    let settingUserProfile   = SettingsCoordinator()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuBar()
        enableCoordinatorPattern()
    }
    
    // MARK: - Private
    private func setupMenuBar() {
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 20
        tabBar.tintColor = UIColor(red: 27/255, green: 183/255, blue: 233/255, alpha: 1)
        tabBar.barTintColor = UIColor(red: 53/255, green: 42/255, blue: 129/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 53/255, green: 42/255, blue: 129/255, alpha: 1)
    }
    
    private func enableCoordinatorPattern() {
        chosenCryptocurrency.start()
        detailCryptocurrency.start()
        selectCryptocurrency.start()
        settingUserProfile.start()
        viewControllers = [chosenCryptocurrency.navigationController, detailCryptocurrency.navigationController, selectCryptocurrency.navigationController, settingUserProfile.navigationController]
    }
}
