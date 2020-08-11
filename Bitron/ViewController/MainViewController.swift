//
//  ViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    var timer: Timer?
    let colors = Colors()
    let initObjects = MainView()
    let reuseIdentifier = "reuseCell"
    let networking = Networking.shared
    let persistence = Persistence.shared
    var cryptoNames = [""]
    var cryptoRates = [""]
    var chosenCryptoNames: [String] = []
    var chosenCryptoRates: [String] = []
    var chosenCryptoTime: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        initObjectsActions()
        retriveData()

        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] (_) in
            self?.parseJSONData()
        })
    }
        
    override func loadView() {
        super.loadView()
            
        view = initObjects
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            
        parseJSONData()
    }
    
    func setupView() {
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCryptoButtonPressed))
        view.layer.insertSublayer(colors.gradientColor, at: 0)
        navigationItem.title = "Bitron"
        navigationItem.setHidesBackButton(true, animated: true)
    }
        
    func initObjectsActions() {
            
        initObjects.mainTableView.register(MainCell.self, forCellReuseIdentifier: reuseIdentifier)
        initObjects.mainTableView.delegate = self
        initObjects.mainTableView.dataSource = self
    }
        
    @objc func addCryptoButtonPressed() {
            
        coordinator?.cryptoView()
    }
        
    func parseJSONData() {

        DispatchQueue.main.async {
                
            let urlPath = "https://api.bitbay.net/rest/trading/ticker"
            self.networking.request(urlPath) { [weak self] (result) in
                    
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(Crypto.self, from: data)
                           
                        self?.cryptoRates = [
                            response.items.btc.rate,
                            response.items.eth.rate,
                            response.items.ltc.rate,
                            response.items.lsk.rate,
                            response.items.alg.rate,
                            response.items.trx.rate,
                            response.items.amlt.rate,
                            response.items.neu.rate,
                            response.items.bob.rate,
                            response.items.xrp.rate
                        ]
                        
                        var currentIndex = 0
                            
                        for name in self?.chosenCryptoNames ?? [] {
                            
                            switch(name) {
                            case "BTC-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.btc.rate
                            case "ETH-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.eth.rate
                            case "LTC-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.ltc.rate
                            case "LSK-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.lsk.rate
                            case "ALG-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.alg.rate
                            case "TRX-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.trx.rate
                            case "AMLT-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.amlt.rate
                            case "NEU-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.neu.rate
                            case "BOB-PLN":
                                self?.chosenCryptoRates[currentIndex] = response.items.bob.rate
                            default:
                                self?.chosenCryptoRates[currentIndex] = response.items.xrp.rate
                            }
                            currentIndex += 1
                        }

                        DispatchQueue.main.async {
                            self?.initObjects.mainTableView.reloadData()
                        }
                        
                    } catch let error {
                        print(error)
                    }
                        
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
        
    func retriveData() {
            
        let context = persistence.context
            
        let fetchRequest = NSFetchRequest<CryptoModel>(entityName: "CryptoModel")
                
        do {
            let results = try context.fetch(fetchRequest)
                    
            for result in results {
                    
                guard let readTitle = result.title else { return }
                chosenCryptoNames.append(readTitle)
                    
                guard let readValue = result.value else { return }
                chosenCryptoRates.append(readValue)
                    
                let readTime = result.time
                chosenCryptoTime.append(Int(readTime))
            }
                    
            DispatchQueue.main.async {
                self.initObjects.mainTableView.reloadData()
            }
                
        } catch {
            print("Could not retrive data")
        }
    }
}

extension MainViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return chosenCryptoNames.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = initObjects.mainTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MainCell else { return UITableViewCell() }
            
        cell.textLabel?.text = chosenCryptoNames[indexPath.row]
        cell.detailTextLabel?.text = chosenCryptoRates[indexPath.row]
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        coordinator?.detailView(name: chosenCryptoNames[indexPath.row], rate: chosenCryptoRates[indexPath.row])
            //.detailView(to: chosenCryptoNames[indexPath.row])
    }
}

