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
        controller.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), selectedImage: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).withTintColor(.white))
        controller.coordinatorDetail = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func pushToChosenViewController() {
        let controller = ChosenCryptocurrencyViewController()
        controller.coordinatorDetail = self
        navigationController.pushViewController(controller, animated: true)
    }
}
