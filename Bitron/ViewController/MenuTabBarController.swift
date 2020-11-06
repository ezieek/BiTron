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
    let screen = UIScreen.main.bounds
    let chosenCryptocurrency = ChosenCryptocurrencyCoordinator()
    let selectCryptocurrency = SelectCryptocurrencyCoordinator()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuBar()
        chosenCryptocurrency.start()
        selectCryptocurrency.start()
        viewControllers = [chosenCryptocurrency.navigationController, selectCryptocurrency.navigationController]
    }
    
    // MARK: - Private
    private func setupMenuBar() {
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 20
        tabBar.tintColor = UIColor(red: 27/255, green: 183/255, blue: 233/255, alpha: 1)
        tabBar.barTintColor = UIColor(red: 53/255, green: 42/255, blue: 129/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 53/255, green: 42/255, blue: 129/255, alpha: 1)
    }
}
