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
    private lazy var model: [ChosenCryptocurrencyModel] = [ChosenCryptocurrencyModel]()
    private lazy var contentView = ChosenCryptocurrencyView()
    private lazy var settingBackgroundColor = Colors()
    private lazy var chosenViewModel = ChosenCryptocurrencyViewModel()
    private lazy var reuseIdentifier = "reuseCell"
    private lazy var refreshControl = UIRefreshControl()

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        chosenViewModel.getCurrentValue { (model) in
            DispatchQueue.main.async {
                self.model = model
                self.contentView.mainTableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        chosenViewModel.turnOffTheCounter()
    }

    // MARK: - private
    private func setupView() {
        navigationItem.title = "Bitron"
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: contentView.menuBarButtonItem)
        view.layer.insertSublayer(settingBackgroundColor.gradientColor, at: 0)
        refreshControl.tintColor = .white
        //refreshControl.addTarget(self, action: #selector(refreshingTable), for: .valueChanged)
    }

    private func contentViewActions() {
        contentView.mainTableView.register(ChosenCryptocurrencyCell.self, forCellReuseIdentifier: reuseIdentifier)
        contentView.mainTableView.delegate = self
        contentView.mainTableView.dataSource = self
        contentView.mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentView.menuBarButtonItem.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        contentView.mainTableView.addSubview(refreshControl)
    }
    
    private func pushToDetailViewController(indexPath: IndexPath) {
        let model = self.model[indexPath.row]
        coordinatorChosen?.pushToDetailCryptocurrencyViewController(
            name: model.name,
            subname: model.subName,
            rate: model.rate,
            previousRate: model.previousRate,
            image: model.image)
    }
    
    /*
    // MARK: - @objc selectors
    @objc private func refreshingTable() {
        self.chosenViewModel.getCurrentValueOfSavedCryptocurrenciesNextLoadView { [weak self] in
            self?.contentView.mainTableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }*/
    
    @objc private func settingsButtonPressed() {
        print("The setting button has been pressed")
    }
}

    // MARK: - DataSource
extension ChosenCryptocurrencyViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.mainTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ChosenCryptocurrencyCell else { return UITableViewCell() }

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func configureCell(cell: ChosenCryptocurrencyCell, indexPath: IndexPath) {
        
        let model = self.model[indexPath.row]

        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.subName
        cell.imageView?.image = UIImage(named: model.image)
        cell.cryptoValueLabel.text = "\(model.rate) PLN"
        cell.cryptoSubValueLabel.text = "\(model.previousRate) %"
        cell.cryptoSubValueLabel.textColor = model.color
        cell.selectionStyle = .none
    }
}

    // MARK: - Delegate
extension ChosenCryptocurrencyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !model.isEmpty {
            pushToDetailViewController(indexPath: indexPath)
        } else {
            print("An error occured. Model is empty!")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
