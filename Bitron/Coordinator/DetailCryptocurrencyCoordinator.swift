//
//  DetailCryptocurrencyCoordinator.swift
//  Bitron
//
//  Created by Maciej Wołejko on 11/9/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class DetailCryptocurrencyCoordinator: Coordinator {
    
    override func start() {
        super.start()
        
        let controller = DetailCryptocurrencyViewController()
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        controller.coordinatorDetail = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func pushToChosenViewController() {
        let controller = ChosenCryptocurrencyViewController()
        controller.coordinatorDetail = self
        navigationController.pushViewController(controller, animated: true)
    }
}
