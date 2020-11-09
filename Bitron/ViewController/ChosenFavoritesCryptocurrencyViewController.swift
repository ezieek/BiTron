//
//  ChosenFavoritesCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class ChosenCryptocurrencyViewController: UIViewController {
    
    //MARK: - Properties
    weak var coordinatorChosen: ChosenCryptocurrencyCoordinator?
    weak var coordinatorDetail: DetailCryptocurrencyCoordinator?
    private lazy var contentView = ChosenCryptocurrencyView()
    private lazy var settingBackgroundColor = Colors()
    private lazy var favoritesViewModel = ChosenCryptocurrencyViewModel()
    private lazy var reuseIdentifier = "reuseCell"
    private lazy var timeInterval = 5.0
    private lazy var refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        contentViewActions()
        dataViewModelActions()
    }
        
    override func loadView() {
        super.loadView()
            
        view = contentView
    }

    // MARK: - private
    private func setupView() {
        navigationItem.title = "Bitron"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: contentView.menuBarButtonItem)
        view.layer.insertSublayer(settingBackgroundColor.gradientColor, at: 0)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshingTable), for: .valueChanged)
    }

    private func contentViewActions() {
        contentView.mainTableView.register(ChosenCryptocurrencyCell.self, forCellReuseIdentifier: reuseIdentifier)
        contentView.mainTableView.delegate = self
        contentView.mainTableView.dataSource = self
        contentView.mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentView.menuBarButtonItem.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        contentView.mainTableView.addSubview(refreshControl)
    }
    
    private func dataViewModelActions() {
        self.favoritesViewModel.getCurrentValueOfSavedCryptocurrenciesFirstLoadView { [weak self] in
            self?.contentView.mainTableView.reloadData()
        }

        self.favoritesViewModel.getCurrentValueOfSavedCryptocurrenciesNextLoadView(timeInterval: timeInterval) { [weak self] in
            self?.contentView.mainTableView.reloadData()
        }
    }

    // MARK: - @objc selectors
    @objc func refreshingTable() {
        self.favoritesViewModel.getCurrentValueOfSavedCryptocurrenciesFirstLoadView { [weak self] in
            self?.contentView.mainTableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc private func settingsButtonPressed() {
        print("The setting button has been pressed")
    }
}

    // MARK: - DataSource
extension ChosenCryptocurrencyViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesViewModel.assignedCryptoNames.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.mainTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ChosenCryptocurrencyCell else { return UITableViewCell() }

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureCell(cell: ChosenCryptocurrencyCell, indexPath: IndexPath) {
        cell.textLabel?.text = favoritesViewModel.assignedCryptoNames[indexPath.row]
        cell.detailTextLabel?.text = favoritesViewModel.assignedCryptoSubNames[indexPath.row]
        cell.imageView?.image = UIImage(named: favoritesViewModel.assignedCryptoIcon[indexPath.row])
        cell.cryptoValueLabel.text = "\(favoritesViewModel.assignedCryptoRates[indexPath.row])  PLN"
        cell.cryptoSubValueLabel.text = "\(favoritesViewModel.assignedCryptoPreviousRates[indexPath.row]) %"
        cell.cryptoSubValueLabel.textColor = favoritesViewModel.percentColors[indexPath.row]
    }
}

    // MARK: - Delegate
extension ChosenCryptocurrencyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.selectedIndex = 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
