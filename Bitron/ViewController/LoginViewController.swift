//
//  LoginViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/14/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    let initObjects = LoginView()
    let colors = Colors()

    override func viewDidLoad() {
        super.viewDidLoad()

        //view.layer.insertSublayer(colors.gradientColor, at: 0)
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(moveButtonPressed))
    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
    }
    
    @objc func moveButtonPressed() {
        
        coordinator?.mainView()
    }

}
