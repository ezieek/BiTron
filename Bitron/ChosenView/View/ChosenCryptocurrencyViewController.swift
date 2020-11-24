//
//  ChosenCryptocurrencyViewController.swift
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
    private lazy var chosenViewModel = ChosenCryptocurrencyViewModel()
    private lazy var reuseIdentifier = "reuseCell"
    private lazy var refreshControl = UIRefreshControl()
    weak var timer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        contentViewActions()
    }
        
    override func loadView() {
        super.loadView()
            
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        dataViewModelActionsWithTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        chosenViewModel.timer?.invalidate()
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
    
    private func dataViewModelActionsWithTimer() {
        self.chosenViewModel.getCurrentValueOfSavedCryptocurrenciesNextLoadView { [weak self] in
            self?.contentView.mainTableView.reloadData()
        }
    }
    
    private func pushToDetailViewController(indexPath: IndexPath) {
        coordinatorChosen?.pushToDetailCryptocurrencyViewController(
            name: chosenViewModel.chosenCryptocurrencyNames[indexPath.row],
            subname: chosenViewModel.chosenCryptocurrencySubNames[indexPath.row],
            rate: chosenViewModel.chosenCryptocurrencyRates[indexPath.row],
            previousRate: chosenViewModel.chosenCryptocurrencyPreviousRates[indexPath.row],
            image: chosenViewModel.chosenCryptocurrencyImages[indexPath.row])
    }

    // MARK: - @objc selectors
    @objc private func refreshingTable() {
        self.chosenViewModel.getCurrentValueOfSavedCryptocurrenciesNextLoadView { [weak self] in
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
        return chosenViewModel.chosenCryptocurrencyNames.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.mainTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ChosenCryptocurrencyCell else { return UITableViewCell() }

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureCell(cell: ChosenCryptocurrencyCell, indexPath: IndexPath) {
        cell.textLabel?.text = chosenViewModel.chosenCryptocurrencyNames[indexPath.row]
        cell.detailTextLabel?.text = chosenViewModel.chosenCryptocurrencySubNames[indexPath.row]
        cell.imageView?.image = UIImage(named: chosenViewModel.chosenCryptocurrencyImages[indexPath.row])
        cell.cryptoValueLabel.text = "\(chosenViewModel.chosenCryptocurrencyRates[indexPath.row])  PLN"
        cell.cryptoSubValueLabel.text = "\(chosenViewModel.chosenCryptocurrencyPreviousRates[indexPath.row]) %"
        cell.cryptoSubValueLabel.textColor = chosenViewModel.percentColors[indexPath.row]
        cell.selectionStyle = .none
    }
}

    // MARK: - Delegate
extension ChosenCryptocurrencyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if !chosenViewModel.chosenCryptocurrencyNames.isEmpty {
            DispatchQueue.main.async {
                self.pushToDetailViewController(indexPath: indexPath)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                print("Empty")
                self.pushToDetailViewController(indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
