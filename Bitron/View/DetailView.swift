//
//  DetailView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class DetailView: UIView {

    lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        [rateLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            rateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            rateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
