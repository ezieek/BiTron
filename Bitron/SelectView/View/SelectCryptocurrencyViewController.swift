//
//  SelectCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class SelectCryptocurrencyViewController: UIViewController {

    // MARK: - Properties
    weak var coordinatorSelect: SelectCryptocurrencyCoordinator?
    weak var coordinatorChosen: ChosenCryptocurrencyCoordinator?
    private lazy var model: [SelectCryptocurrencyModel] = [SelectCryptocurrencyModel]()
    private lazy var contentView = SelectCryptocurrencyView()
    private lazy var settingBackgroundColor = Colors()
    private lazy var selectViewModel = SelectCryptocurrencyViewModel()
    private lazy var reuseIdentifier = "reuseCell"

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
        
        selectViewModel.getJSON { (model) in
            self.model = model
            self.contentView.cryptoTableView.reloadData()
        }
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
}

    // MARK: - DataSource
extension SelectCryptocurrencyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.cryptoTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SelectCryptocurrencyCell else { return UITableViewCell() }
            
        configureCell(cell: cell, indexPath: indexPath)
       
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        let model = self.model[indexPath.row]
        
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.rate
        cell.imageView?.image = UIImage(named: model.image ?? "")
        cell.accessoryType = .detailButton
        cell.tintColor = .white
        cell.selectionStyle = .none
    }
}

    // MARK: - Delegate
extension SelectCryptocurrencyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectViewModel.saveCryptocurrencyData(indexPath: indexPath)
        self.tabBarController?.selectedIndex = 0
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //coordinatorSelect?.pushToDetailCryptocurrencyViewController(name: cryptocurrencyViewModel.cryptocurrencyNames[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
