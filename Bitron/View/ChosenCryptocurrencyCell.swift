//
//  ChosenCryptocurrencyCell.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class ChosenCryptocurrencyCell: UITableViewCell {

    //MARK: - Properties
    let screen = UIScreen.main.bounds
    
    lazy var cryptoValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cryptoSubValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - init - deinit
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupColors()
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame.origin.y = 30
        detailTextLabel?.frame.origin.y = 54
    }
    
    // MARK: - internal
    func setupColors() {
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .gray
        backgroundColor = .clear
    }
    
    func createSubViews() {
        [cryptoValueLabel, cryptoSubValueLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            cryptoValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            cryptoValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cryptoSubValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 54),
            cryptoSubValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
