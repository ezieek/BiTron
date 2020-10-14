//
//  FavoritesCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class FavoritesCryptocurrencyViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    private let dataViewModel = FavoritesCryptocurrencyViewModel()
    private let initObjects = MainView()
    private let colors = Colors()
    private let reuseIdentifier = "reuseCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        dataViewModelActions()
    }
        
    override func loadView() {
        super.loadView()
            
        view = initObjects
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        dataViewModel.turnOffTheCounter()
    }
    
    private func dataViewModelActions() {

        self.dataViewModel.getCurrentValueOfSavedCryptocurrenciesFirstLoadView { [weak self] in
            self?.initObjects.mainTableView.reloadData()
        }

        self.dataViewModel.getCurrentValueOfSavedCryptocurrenciesNextLoadView(timeInterval: 5.0) { [weak self] in
            self?.initObjects.mainTableView.reloadData()
        }
    }
    
    private func setupView() {
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: initObjects.menuBarButtonItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCryptoButtonPressed))
        view.layer.insertSublayer(colors.gradientColor, at: 0)
        navigationItem.title = "Bitron"
        navigationItem.setHidesBackButton(true, animated: true)
        initObjects.menuBarButtonItem.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        initObjects.mainTableView.register(MainCell.self, forCellReuseIdentifier: reuseIdentifier)
        initObjects.mainTableView.delegate = self
        initObjects.mainTableView.dataSource = self
        initObjects.mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        initObjects.deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }
    
    @objc private func deleteButtonPressed() {
    
        print("The delete button has been pressed")
    }
        
    @objc private func settingsButtonPressed() {
        
        print("The setting button has been pressed")
    }
    
    @objc private func addCryptoButtonPressed() {
            
        coordinator?.cryptoView()
    }
}

extension FavoritesCryptocurrencyViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
        return dataViewModel.assignedCryptoNames.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = initObjects.mainTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MainCell else { return UITableViewCell() }

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureCell(cell: MainCell, indexPath: IndexPath) {

        cell.textLabel?.text = dataViewModel.assignedCryptoNames[indexPath.row]
        cell.detailTextLabel?.text = dataViewModel.assignedCryptoSubNames[indexPath.row]
        cell.cryptoValueLabel.text = "\(dataViewModel.assignedCryptoRates[indexPath.row])  PLN"
        cell.cryptoSubValueLabel.text = "\(dataViewModel.assignedCryptoPreviousRates[indexPath.row]) %"
        cell.cryptoSubValueLabel.textColor = dataViewModel.percentColors[indexPath.row]
    }
}

extension FavoritesCryptocurrencyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        coordinator?.detailView(name: dataViewModel.assignedCryptoNames[indexPath.row], subName: dataViewModel.assignedCryptoSubNames[indexPath.row], rate: dataViewModel.assignedCryptoRates[indexPath.row], previousRate: dataViewModel.assignedCryptoPreviousRates[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
