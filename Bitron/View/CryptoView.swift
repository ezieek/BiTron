//
//  CryptoView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class CryptoView: UIView {
    
    lazy var cryptoTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
     
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        
        [cryptoTableView].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            cryptoTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            cryptoTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cryptoTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cryptoTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
