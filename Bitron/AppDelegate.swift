//
//  AppDelegate.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinator: ApplicationCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       /* let window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = ApplicationCoordinator(window: window)
        coordinator?.start()*/
        
        
        // create the main navigation controller to be used for our up
        let rootViewController = LoginViewController()
        let navController = UINavigationController(rootViewController: rootViewController)
        
        // send that into our coordinator so that it can display vc
        coordinator = ApplicationCoordinator(navigationController: navController)

        // tell the coordinator to take over control
        coordinator?.start()
        
        // create a basic UIWindow and activate it
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        setupAppearance()
        
        return true
    }
    
    // MARK: - Appearance
    fileprivate func setupAppearance() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.007, green: 0.12, blue: 0.26, alpha: 1.00)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
    }
    
}
