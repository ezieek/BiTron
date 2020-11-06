//
//  SettingsCoordinator.swift
//  Bitron
//
//  Created by Maciej Wołejko on 11/6/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class SettingsCoordinator: Coordinator {
    
    override func start() {
        super.start()
        let controller = SettingsViewController()
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
