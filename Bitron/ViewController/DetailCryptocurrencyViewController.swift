//
//  DetailCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class DetailCryptocurrencyViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinatorDetail: DetailCryptocurrencyCoordinator?
    weak var coordinatorChosen: ChosenCryptocurrencyCoordinator?
    weak var coordinatorSelect: SelectCryptocurrencyCoordinator?
    private lazy var contentView = DetailView()
    private lazy var settingBackgroundColor = Colors()
    private lazy var detailViewModel = DetailViewModel()
    let networking = Networking.shared
    let persistence = Persistence.shared
    var pushedCryptocurrencyName: String = ""
    var pushedCryptocurrencySubName: String = ""
    var pushedCryptocurrencyRate: String = ""
    var pushedCryptocurrencyPreviousRate: String = ""
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        (tabBarController as! MenuTabBarController).data = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushedCryptocurrencyName = (tabBarController as! MenuTabBarController).data
        //detailViewModel.detailCryptocurrencyShortName.append(pushedCryptocurrencySubName)
        detailViewModel.detailCryptocurrencyShortName.append(pushedCryptocurrencyName)
        setupView()
        contentViewActions()
        detailViewModel.getJSON {
            self.contentView.cryptocurrencyVolumeLabel.text = self.detailViewModel.detailCryptocurrencyVolumeValue
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }

    // MARK: - private
    private func setupView() {
        navigationItem.title = "\(detailViewModel.detailCryptocurrencyShortName) (\(pushedCryptocurrencySubName))"
        view.layer.insertSublayer(settingBackgroundColor.gradientColor, at: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .done, target: self, action: #selector(backButtonPressed))
    }
    
    private func contentViewActions() {
        contentView.cryptocurrencyNameLabel.text = "\(pushedCryptocurrencySubName) / PLN"
        contentView.cryptocurrencyRateLabel.text = "\(pushedCryptocurrencyRate) PLN"
        contentView.cryptocurrencyPercentageRateLabel.text = "tak"
        contentView.cryptocurrencyVolumeLabel.text = "Volume 24h PLN"
        //contentView.pushNotificationButton.addTarget(self, action: #selector(deleteDataButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - @objc selectors
    @objc private func backButtonPressed() {
        tabBarController?.selectedIndex = 0
    }
}
