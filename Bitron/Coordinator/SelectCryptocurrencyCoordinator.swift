//
//  SelectCryptocurrencyCoordinator.swift
//  Bitron
//
//  Created by Maciej Wołejko on 11/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class SelectCryptocurrencyCoordinator: Coordinator {
    
    override func start() {
        super.start()
        
        let controller = SelectCryptocurrencyViewController()
        controller.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), selectedImage: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).withTintColor(.white))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func pushToDetailViewController(name: String) {
        let controller = DetailCryptocurrencyViewController()
        controller.pushedCryptocurrencyName = name
        controller.pushedCryptocurrencyRate = name
        controller.pushedCryptocurrencySubName = name
        controller.coordinatorSelect = self
        navigationController.pushViewController(controller, animated: true)
    }
    
}
