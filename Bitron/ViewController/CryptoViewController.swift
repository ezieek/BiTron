//
//  CryptoViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class CryptoViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
        
    let reuseIdentifier = "reuseCell"
        
    let colors = Colors()
    let initObjects = CryptoView()
    let networking = Networking.shared
    let persistence = Persistence.shared
    var cryptoViewModel: [CryptoViewModel] = []
    var cryptoNames = [""]
    var cryptoRates = [""]
    var storedCrypto = [""]
    var filteredData: [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        initObjectsActions()
        readData()
        updateCell()
    }
    
    override func loadView() {
        super.loadView()
            
        view = initObjects
    }
    
    func setupView() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationItem.setHidesBackButton(true, animated: true)
        view.layer.insertSublayer(colors.gradientColor, at: 0)
        navigationItem.title = "Bitron"
    }
    
    func initObjectsActions() {
            
        initObjects.cryptoTableView.register(CryptoCell.self, forCellReuseIdentifier: reuseIdentifier)
        initObjects.cryptoTableView.delegate = self
        initObjects.cryptoTableView.dataSource = self
    }
    
    @objc func backButtonPressed() {
        
        coordinator?.mainView()
    }
    
    func updateCell() {
            
        DispatchQueue.main.async {
            self.readData()
        }
    }
        
    func readData() {

        DispatchQueue.main.async {
            let urlPath = "https://api.bitbay.net/rest/trading/ticker"
            self.networking.request(urlPath) { [weak self] (result) in
     
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(Crypto.self, from: data)

                        self?.cryptoNames = [
                                response.items.btc.market.code,
                                response.items.eth.market.code,
                                response.items.ltc.market.code,
                                response.items.lsk.market.code,
                                response.items.alg.market.code,
                                response.items.trx.market.code,
                                response.items.amlt.market.code,
                                response.items.neu.market.code,
                                response.items.bob.market.code,
                                response.items.xrp.market.code
                        ]

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
                            
                        DispatchQueue.main.async {
                            self?.initObjects.cryptoTableView.reloadData()
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
        
    func createData(title: String, value: String, time: Int) {
            
        let context = persistence.context
             
        guard let userEntity = NSEntityDescription.entity(forEntityName: "CryptoModel", in: context) else { return }
             
        let newValue = NSManagedObject(entity: userEntity, insertInto: context)
        newValue.setValue(title, forKey: "title")
        newValue.setValue(value, forKey: "value")
        newValue.setValue(time, forKey: "time")
            
        do {
            try context.save()
        } catch {
            print("Saving error")
        }
    }
        
    func retriveData() {
            
        let context = persistence.context
            
        let fetchRequest = NSFetchRequest<CryptoModel>(entityName: "CryptoModel")
            
        do {
            let results = try context.fetch(fetchRequest)
                    
            for result in results {
                guard let readTitle = result.title else { return }
                storedCrypto.append(readTitle)
            }
        } catch {
            print("Could not retrive data")
        }
    }
}

extension CryptoViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return cryptoNames.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = initObjects.cryptoTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CryptoCell else { return UITableViewCell() }
            
        cell.textLabel?.text = cryptoNames[indexPath.row]
        cell.detailTextLabel?.text = cryptoRates[indexPath.row]
        return cell
    }
}

extension CryptoViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
        return 50
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        let name = cryptoNames[indexPath.row]
        let rate = cryptoRates[indexPath.row]
        let time = Int(Date().timeIntervalSince1970)

        retriveData()
            
        let filterData = Array(NSOrderedSet(array: storedCrypto))
            
        filteredData = filterData.map { ($0 as? String ?? "") }
            
        if !filteredData.contains(name) {
            createData(title: name, value: rate, time: time)
        }
            
        coordinator?.mainView()
    }
}
