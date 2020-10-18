//
//  FavoriteView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class FavoriteView: UIView {

    let screen = UIScreen.main.bounds
    
    lazy var menuBarButtonItem: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menu")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var favouritesLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourites"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorColor = .white
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pushNotificationButton, deleteButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var pushNotificationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Push Enabled?", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Crypto?", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        
        [favouritesLabel, mainTableView, bottomStackView].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            favouritesLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            favouritesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainTableView.topAnchor.constraint(equalTo: favouritesLabel.bottomAnchor, constant: 0),
            mainTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainTableView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor),
            bottomStackView.topAnchor.constraint(equalTo: topAnchor, constant: 550),
            bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}