//
//  MainView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class MainView: UIView {

    let screen = UIScreen.main.bounds
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorColor = .white
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        
        [mainTableView].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
