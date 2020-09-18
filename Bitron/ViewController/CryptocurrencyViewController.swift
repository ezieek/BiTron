//
//  CryptoViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class CryptocurrencyViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    private let initObjects = CryptoView()
    private let dataViewModel = CryptocurrencyViewModel()
    private let reuseIdentifier = "reuseCell"
    private let colors = Colors()
    private var cryptocurrencyName: [String] = []
    private var cryptocurrencyRate: [String] = []
    private var cryptocurrencyPreviousRate: [String] = []
    private var cryptocurrencyIcons = ["btc"]//, "eth", "ltc", "lsk", "trx", "amlt", "neu", "bob", "xrp"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        dataViewModelActions()
    }
    
    override func loadView() {
        super.loadView()
            
        view = initObjects
    }
    
    func setupView() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationItem.setHidesBackButton(true, animated: true)
        view.layer.insertSublayer(colors.gradientColor, at: 0)
        navigationItem.title = "Bitron"
        initObjects.cryptoTableView.register(CryptoCell.self, forCellReuseIdentifier: reuseIdentifier)
        initObjects.cryptoTableView.delegate = self
        initObjects.cryptoTableView.dataSource = self
        initObjects.cryptoTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func dataViewModelActions() {
        
        dataViewModel.getJSON { [weak self] (names: [String], rates: [String], previousRates: [String])  in
            self?.cryptocurrencyName.append(contentsOf: names)
            self?.cryptocurrencyRate.append(contentsOf: rates)
            self?.cryptocurrencyPreviousRate.append(contentsOf: previousRates)
            self?.initObjects.cryptoTableView.reloadData()
        }
    }
    
    @objc func backButtonPressed() {
        
        coordinator?.mainView()
    }
}

extension CryptocurrencyViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
       return cryptocurrencyName.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = initObjects.cryptoTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CryptoCell else { return UITableViewCell() }
            
        configureCell(cell: cell, indexPath: indexPath)
       
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        
        cell.textLabel?.text = cryptocurrencyName[indexPath.row]
        cell.detailTextLabel?.text = cryptocurrencyRate[indexPath.row]
        cell.imageView?.image = UIImage(named: "btc")//cryptocurrencyIcons)[indexPath.row])
        //ERROR: INDEX OUT OF RANGE
        cell.accessoryType = .detailButton
        cell.tintColor = .white
    }
}

extension CryptocurrencyViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
        return 100
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        dataViewModel.pushDataToMainController(index: indexPath as NSIndexPath)
        coordinator?.mainView()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        coordinator?.detailView(name: cryptocurrencyName[indexPath.row], rate: cryptocurrencyRate[indexPath.row])
    }
}
