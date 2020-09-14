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
        
        let colorTop2 = UIColor(red: 0.18, green: 0.22, blue: 0.26, alpha: 1.00).cgColor
        let colorBottom2 = UIColor(red: 0.27, green: 0.32, blue: 0.37, alpha: 1.00).cgColor

        let colorTop3 = UIColor(red: 0.007, green: 0.12, blue: 0.26, alpha: 1.00).cgColor
        let colorBottom3 = UIColor(red: 0.0, green: 0.16, blue: 0.39, alpha: 1.00).cgColor
        
        let view = UIScreen.main.bounds
        
        gradientColor.frame = view
        gradientColor.colors = [colorTop3, colorBottom3]
    }
}
