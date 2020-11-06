//
//  CryptocurrencyCoordinator.swift
//  Bitron
//
//  Created by Maciej Wołejko on 11/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class CryptocurrencyCoordinator: Coordinator {
    
    override func start() {
        super.start()
        let controller = CryptocurrencyViewController()
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
