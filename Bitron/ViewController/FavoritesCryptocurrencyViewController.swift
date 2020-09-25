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
    weak var timer: Timer?
    private let dataViewModel = FavoritesCryptocurrencyViewModel()
    private let initObjects = MainView()
    private let colors = Colors()
    private let reuseIdentifier = "reuseCell"
    private var cryptocurrencyName: [String] = []
    private var cryptocurrencySubName: [String] = []
    private var cryptocurrencyRate: [String] = []
    private var cryptocurrencyPreviousRate: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        dataViewModelActions()
       //constantlyParsingCryptocurrencyData()
    }
        
    override func loadView() {
        super.loadView()
            
        view = initObjects
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        pauseParsingCryptocurrencyData()
    }
    
    private func dataViewModelActions() {
        
        dataViewModel.getCurrentValueOfSavedCryptocurrencies { [weak self] (name: [String], subName: [String], rate: [String], previousRate: [String]) in
            self?.cryptocurrencyName.append(contentsOf: name)
            self?.cryptocurrencySubName.append(contentsOf: subName)
            self?.cryptocurrencyRate.append(contentsOf: rate)
            self?.cryptocurrencyPreviousRate.append(contentsOf: previousRate)
            self?.initObjects.mainTableView.reloadData()
        }
    }
    
    private func constantlyParsingCryptocurrencyData() {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] (_) in
            
            //dodac:
            //funkcje getCurrentValueOfSavedCryptocurrencies
            //funkcje do zapisu danych do pamieci telefonu
        })
    }
    
    private func pauseParsingCryptocurrencyData() {
        
        timer?.invalidate()
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
    
    @objc func deleteButtonPressed() {
    
        print("The delete button has been pressed")
    }
        
    @objc func settingsButtonPressed() {
        
        print("The setting button has been pressed")
    }
    
    @objc func addCryptoButtonPressed() {
            
        coordinator?.cryptoView()
    }
}

extension FavoritesCryptocurrencyViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return cryptocurrencyName.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = initObjects.mainTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MainCell else { return UITableViewCell() }

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: MainCell, indexPath: IndexPath) {

        cell.textLabel?.text = cryptocurrencyName[indexPath.row]
        cell.detailTextLabel?.text = cryptocurrencySubName[indexPath.row]
        cell.cryptoValueLabel.text = "\(cryptocurrencyRate[indexPath.row])  PLN"
        cell.cryptoSubValueLabel.text = "\(cryptocurrencyPreviousRate[indexPath.row]) %"
        cell.cryptoSubValueLabel.textColor = dataViewModel.percentColors[indexPath.row]
    }
}

extension FavoritesCryptocurrencyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        coordinator?.detailView(name: cryptocurrencyName[indexPath.row], subName: cryptocurrencySubName[indexPath.row], rate: cryptocurrencyRate[indexPath.row], previousRate: cryptocurrencyPreviousRate[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
