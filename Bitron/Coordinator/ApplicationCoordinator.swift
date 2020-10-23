//
//  ApplicationCoordinator.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    //private let window: UIWindow
    
   /* init(window: UIWindow) {
        self.window = window
    }*/
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    func start() {
        /*let viewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()*/
        let viewController = FavoritesCryptocurrencyViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func loginView() {
        let viewController = LoginViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func favoritesView() {
        let viewController = FavoritesCryptocurrencyViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func cryptoView() {
        let viewController = CryptocurrencyViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func detailView(name: String, subName: String, rate: String, previousRate: String) {
        let viewController = DetailCryptocurrencyViewController()
        viewController.pushedCryptocurrencyName = name
        viewController.pushedCryptocurrencySubName = subName
        viewController.pushedCryptocurrencyRate = rate
        viewController.pushedCryptocurrencyPreviousRate = previousRate
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
