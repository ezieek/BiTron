//
//  LoginViewController.swift
//  Bitron
//
//  Created by user175293 on 8/14/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(moveButtonPressed))
    }
    
    @objc func moveButtonPressed() {
        
        coordinator?.mainView()
    }

}
