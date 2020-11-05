//
//  MenuBarViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 11/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class MenuBarViewController: UITabBarController {

    // MARK: - Properties
    let screen = UIScreen.main.bounds
    weak var coordinator: ApplicationCoordinator?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuBar()
    }
    
    func setupMenuBar() {
        
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 20
        tabBar.tintColor = UIColor(red: 27/255, green: 183/255, blue: 233/255, alpha: 1)
        tabBar.barTintColor = UIColor(red: 53/255, green: 42/255, blue: 129/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 53/255, green: 42/255, blue: 129/255, alpha: 1)
        
        let firstViewController = CryptocurrencyViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "BTC"), tag: 0)
        
        let secondViewController = FavoritesCryptocurrencyViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "NO", image: UIImage(named: "ETH"), tag: 0)
        
        viewControllers = [firstViewController, secondViewController]
    }
}
