//
//  SelectCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class SelectCryptocurrencyViewController: UIViewController {

    // MARK: - Properties
    weak var coordinator: SelectCryptocurrencyCoordinator?
    weak var coordinatorChosen: ChosenCryptocurrencyCoordinator?
    private lazy var contentView = SelectCryptocurrencyView()
    private lazy var settingBackgroundColor = Colors()
    private lazy var cryptocurrencyViewModel = SelectCryptocurrencyViewModel()
    private lazy var reuseIdentifier = "reuseCell"

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
        view.layer.insertSublayer(settingBackgroundColor.gradientColor, at: 0)
    }
    
    private func contentViewActions() {
        contentView.cryptoTableView.register(SelectCryptocurrencyCell.self, forCellReuseIdentifier: reuseIdentifier)
        contentView.cryptoTableView.delegate = self
        contentView.cryptoTableView.dataSource = self
        contentView.cryptoTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func dataViewModelActions() {
        cryptocurrencyViewModel.getJSONUsingBitbayAPI { [weak self] in
            self?.contentView.cryptoTableView.reloadData()
        }
    }
}

    // MARK: - DataSource
extension SelectCryptocurrencyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptocurrencyViewModel.cryptocurrencyNames.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.cryptoTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SelectCryptocurrencyCell else { return UITableViewCell() }
            
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

    // MARK: - Delegate
extension SelectCryptocurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cryptocurrencyViewModel.pushDataToChosenViewController(indexPath: indexPath as NSIndexPath)
        tabBarController?.selectedIndex = 0

    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
      // (tabBarController as! MenuTabBarController).data = cryptocurrencyViewModel.cryptocurrencyNames[indexPath.row]
        tabBarController?.selectedIndex = 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
