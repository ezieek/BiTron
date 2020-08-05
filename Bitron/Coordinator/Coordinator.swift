//
//  Coordinator.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    //a property to store any child coordinators
    var childCoordinators: [Coordinator] { get set }

    //a property to store the nav controller thats being used to present VC
    var navigationController: UINavigationController { get set }

    func start()
}
