//
//  CryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class CryptocurrencyViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    private let initObjects = CryptoView()
    private let cryptocurrencyViewModel = CryptocurrencyViewModel()
    private let reuseIdentifier = "reuseCell"
    private let colors = Colors()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        dataViewModelActions()
    }
    
    override func loadView() {
        super.loadView()
            
        view = initObjects
    }
    
    private func setupView() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationItem.setHidesBackButton(true, animated: true)
        view.layer.insertSublayer(colors.gradientColor, at: 0)
        navigationItem.title = "Bitron"
        initObjects.cryptoTableView.register(CryptoCell.self, forCellReuseIdentifier: reuseIdentifier)
        initObjects.cryptoTableView.delegate = self
        initObjects.cryptoTableView.dataSource = self
        initObjects.cryptoTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func dataViewModelActions() {
        
        cryptocurrencyViewModel.getJSONUsingBitbayAPI { [weak self] in
            
            self?.initObjects.cryptoTableView.reloadData()
        }
    }
    
    @objc private func backButtonPressed() {
        
        coordinator?.mainView()
    }
}

extension CryptocurrencyViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return cryptocurrencyViewModel.cryptocurrencyNames.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = initObjects.cryptoTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CryptoCell else { return UITableViewCell() }
            
        configureCell(cell: cell, indexPath: indexPath)
       
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        
        cell.textLabel?.text = cryptocurrencyViewModel.cryptocurrencyNames[indexPath.row]
        cell.detailTextLabel?.text = cryptocurrencyViewModel.cryptocurrencyRates[indexPath.row]
        cell.imageView?.image = UIImage(named: cryptocurrencyViewModel.cryptocurrencyIcon[indexPath.row])
        cell.accessoryType = .detailButton
        cell.tintColor = .white
    }
}

extension CryptocurrencyViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
        return 100
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        cryptocurrencyViewModel.pushDataToFavoritesViewController(indexPath: indexPath as NSIndexPath)
        coordinator?.mainView()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        coordinator?.detailView(name: cryptocurrencyViewModel.cryptocurrencyNames[indexPath.row], subName: cryptocurrencyViewModel.cryptocurrencySubNames[indexPath.row], rate: cryptocurrencyViewModel.cryptocurrencyRates[indexPath.row], previousRate: cryptocurrencyViewModel.cryptocurrencyPreviousRates[indexPath.row])
    }
}
