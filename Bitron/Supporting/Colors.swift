//
//  Colors.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/11/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class Colors {
    
    let gradientColor = CAGradientLayer()

    init() {

        let colorTop = UIColor(red: 0.15, green: 0.18, blue: 0.29, alpha: 1.00).cgColor
        let colorBottom = UIColor(red: 0.09, green: 0.09, blue: 0.14, alpha: 1.00).cgColor
        
        let view = UIScreen.main.bounds
        
        gradientColor.frame = view
        gradientColor.colors = [colorTop, colorBottom]
    }
}
