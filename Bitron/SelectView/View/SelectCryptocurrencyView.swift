//
//  SelectCryptocurrencyView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class SelectCryptocurrencyView: UIView {
    
    // MARK: - Properties
    lazy var cryptoTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorColor = .white
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - init - deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal
    func createSubViews() {
        [cryptoTableView].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            cryptoTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cryptoTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cryptoTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cryptoTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
