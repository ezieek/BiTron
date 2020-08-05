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
    
    init(navigationController: UINavigationController) {
        
        self.navigationController = navigationController
    }
    
    func start() {
        
        let vc = MainViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func mainView() {
        
        let vc = MainViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func cryptoView() {
        
        let vc = CryptoViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func detailView(to productType: String) {
        
        let vc = DetailViewController()
        vc.chosenCryptocurrency = productType
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
