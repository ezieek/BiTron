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
        let vc = ChosenCryptocurrencyViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func loginView() {
        
        let vc = LoginViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func mainView() {
        
        let vc = ChosenCryptocurrencyViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func cryptoView() {
        
        let vc = CryptocurrencyViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func detailView(name: String, rate: String ) {
        
        let vc = DetailViewController()
        vc.chosenCryptocurrencyName = name
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
