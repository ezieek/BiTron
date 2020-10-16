//
//  FavoritesCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class FavoritesCryptocurrencyViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    private let favoritesViewModel = FavoritesCryptocurrencyViewModel()
    private let initObjects = FavoriteView()
    private let colors = Colors()
    private let reuseIdentifier = "reuseCell"
    private var timeInterval = 5.0
    
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
        
        favoritesViewModel.turnOffTheCounter()
    }
    
    private func dataViewModelActions() {

        self.favoritesViewModel.getCurrentValueOfSavedCryptocurrenciesFirstLoadView { [weak self] in
            
            self?.initObjects.mainTableView.reloadData()
        }

        self.favoritesViewModel.getCurrentValueOfSavedCryptocurrenciesNextLoadView(timeInterval: timeInterval) { [weak self] in

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
        initObjects.mainTableView.register(FavoriteCell.self, forCellReuseIdentifier: reuseIdentifier)
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
           
        return favoritesViewModel.assignedCryptoNames.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = initObjects.mainTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FavoriteCell else { return UITableViewCell() }

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureCell(cell: FavoriteCell, indexPath: IndexPath) {

        cell.textLabel?.text = favoritesViewModel.assignedCryptoNames[indexPath.row]
        cell.detailTextLabel?.text = favoritesViewModel.assignedCryptoSubNames[indexPath.row]
        cell.imageView?.image = UIImage(named: favoritesViewModel.assignedCryptoIcon[indexPath.row])
        cell.cryptoValueLabel.text = "\(favoritesViewModel.assignedCryptoRates[indexPath.row])  PLN"
        cell.cryptoSubValueLabel.text = "\(favoritesViewModel.assignedCryptoPreviousRates[indexPath.row]) %"
        cell.cryptoSubValueLabel.textColor = favoritesViewModel.percentColors[indexPath.row]
    }
}

extension FavoritesCryptocurrencyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //delete function for testing
       //favoritesViewModel.deleteCoreData(indexPath: indexPath) {
            
       //   self.initObjects.mainTableView.reloadData()
       //}
        
        coordinator?.detailView(name: favoritesViewModel.assignedCryptoNames[indexPath.row], subName: favoritesViewModel.assignedCryptoSubNames[indexPath.row], rate: favoritesViewModel.assignedCryptoRates[indexPath.row], previousRate: favoritesViewModel.assignedCryptoPreviousRates[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
