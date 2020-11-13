//
//  ChosenCryptocurrencyCoordinator.swift
//  Bitron
//
//  Created by Maciej Wołejko on 11/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class ChosenCryptocurrencyCoordinator: Coordinator {
    
    override func start() {
        super.start()
        
        let controller = ChosenCryptocurrencyViewController()
        controller.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), selectedImage: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal).withTintColor(.white))
        controller.coordinatorChosen = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    /*
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        if navigationController.viewControllers.contains(fromViewController) { return }
        
        if let viewController = fromViewController as? ChosenCryptocurrencyViewController {
            didDismiss(viewController.coordinatorChosen)
        }
    }*/
 
}
