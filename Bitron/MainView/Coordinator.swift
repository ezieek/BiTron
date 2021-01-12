//
//  Coordinator.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class Coordinator: NSObject {
    
    var childCoordinators = [Coordinator]()
    var navigationController = UINavigationController()

    func start() { }
    
    func didDismiss(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
                childCoordinators.remove(at: index)
                break
        }
    }
}
