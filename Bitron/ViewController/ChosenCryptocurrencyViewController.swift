//
//  ChosenCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 04/08/2020.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class ChosenCryptocurrencyViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    weak var timer: Timer?
    private let dataViewModel = ChosenCryptocurrencyViewModel()
    private let initObjects = MainView()

    let colors = Colors()
    let reuseIdentifier = "reuseCell"
    let networking = Networking.shared
    let persistence = Persistence.shared
    var cryptoNames = [""]
    var cryptoRates = [""]
    var cryptoPreviousRates = [""]
    var assignedCryptoNames: [String] = []
    var assignedCryptoSubNames: [String] = []
    var assignedCryptoIcon: [String] = []
    var assignedCryptoPreviousRates: [String] = []
    var chosenCryptoNames: [String] = []
    var chosenCryptoRates: [String] = []
    var chosenCryptoPreviousRates: [String] = []
    var percentColors: [UIColor] = []
    var percentResult = 0.0
    
    private var cryptocurrencyName: [String] = []
    private var cryptocurrencyRate: [String] = []
    private var cryptocurrencyPreviousRate: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        /*dataViewModel.retriveCoreData { [weak self] (names: [String], rates: [String], previousRates: [String])  in
            
            self?.cryptocurrencyName.append(contentsOf: names)
            self?.cryptocurrencyRate.append(contentsOf: rates)
            self?.cryptocurrencyPreviousRate.append(contentsOf: previousRates)
            self?.initObjects.mainTableView.reloadData()
        }
        
        dataViewModel.getJSON()*/
        retriveCoreData()
        parseJSONData()
        startTimer()
    }
        
    override func loadView() {
        super.loadView()
            
        view = initObjects
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        stopTimer()
    }
    
    func startTimer() {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] (_) in
            self?.parseJSONData()
            //self?.updateData(title: "BTC-PLN", value: "10000.0", previousRate: "9999.0")

        })
    }
    
    func stopTimer() {
        
        timer?.invalidate()
    }
    
   /* deinit {
        
        stopTimer()
    }*/
    
    func setupView() {
            
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
        

        print(2)
    }
        
    @objc func settingsButtonPressed() {
        
        print(1)
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
                            response.items.trx.rate,
                            response.items.amlt.rate,
                            response.items.neu.rate,
                            response.items.bob.rate,
                            response.items.xrp.rate
                        ]
                        
                        self?.cryptoPreviousRates = [
                            response.items.btc.previousRate,
                            response.items.eth.previousRate,
                            response.items.ltc.previousRate,
                            response.items.lsk.previousRate,
                            response.items.trx.previousRate,
                            response.items.amlt.previousRate,
                            response.items.neu.previousRate,
                            response.items.bob.previousRate,
                            response.items.xrp.previousRate
                        ]
                        
                        var currentIndex = 0
                        
                        for name in self?.chosenCryptoNames ?? [] {
                            
                            switch(name) {
                                
                            case "BTC-PLN":
                                let btcRate = response.items.btc.rate
                                let btcPreviousRate = response.items.btc.previousRate
                                self?.chosenCryptoRates[currentIndex] = btcRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: btcRate, previousRate: btcPreviousRate, index: currentIndex) ?? "")

                            case "ETH-PLN":
                                let ethRate = response.items.eth.rate
                                let ethPreviousRate = response.items.eth.previousRate
                                self?.chosenCryptoRates[currentIndex] = ethRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: ethRate, previousRate: ethPreviousRate, index: currentIndex) ?? "")

                            case "LTC-PLN":
                                let ltcRate = response.items.ltc.rate
                                let ltcPreviousRate = response.items.ltc.previousRate
                                self?.chosenCryptoRates[currentIndex] = ltcRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: ltcRate, previousRate: ltcPreviousRate, index: currentIndex) ?? "")

                            case "LSK-PLN":
                                let lskRate = response.items.lsk.rate
                                let lskPreviousRate = response.items.lsk.previousRate
                                self?.chosenCryptoRates[currentIndex] = lskRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: lskRate, previousRate: lskPreviousRate, index: currentIndex) ?? "")
                                
                            case "TRX-PLN":
                                let trxRate = response.items.trx.rate
                                let trxPreviousRate = response.items.trx.previousRate
                                self?.chosenCryptoRates[currentIndex] = trxRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: trxRate, previousRate: trxPreviousRate, index: currentIndex) ?? "")
                                
                            case "AMLT-PLN":
                                let amltRate = response.items.amlt.rate
                                let amltPreviousRate = response.items.amlt.previousRate
                                self?.chosenCryptoRates[currentIndex] = amltRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: amltRate, previousRate: amltPreviousRate, index: currentIndex) ?? "")
                                
                            case "NEU-PLN":
                                let neuRate = response.items.neu.rate
                                let neuPreviousRate = response.items.neu.previousRate
                                self?.chosenCryptoRates[currentIndex] = neuRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: neuRate, previousRate: neuPreviousRate, index: currentIndex) ?? "")
                                
                            case "BOB-PLN":
                                let bobRate = response.items.bob.rate
                                let bobPreviousRate = response.items.bob.previousRate
                                self?.chosenCryptoRates[currentIndex] = bobRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: bobRate, previousRate: bobPreviousRate, index: currentIndex) ?? "")
                                
                            case "GNT-PLN":
                                self?.chosenCryptoRates[currentIndex] = "1111111"
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: "1111111", previousRate: "22222222", index: currentIndex) ?? "")

                            default:
                                let xrpRate = response.items.xrp.rate
                                let xrpPreviousRate = response.items.xrp.previousRate
                                self?.chosenCryptoRates[currentIndex] = xrpRate
                                self?.assignedCryptoPreviousRates[currentIndex] = String(self?.percentageValue(rate: xrpRate, previousRate: xrpPreviousRate, index: currentIndex) ?? "")
                            }
                            
                            
                            DispatchQueue.main.async {
                                
                                self?.initObjects.mainTableView.reloadData()
                            }
                            
                            currentIndex += 1
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
    
    func retriveCoreData() {
            
        let context = persistence.context
            
        let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
                
        do {
            let results = try context.fetch(fetchRequest)
                    
            for result in results {
                    
                guard let readTitle = result.title else { return }
                chosenCryptoNames.append(readTitle)
                    
                guard let readValue = result.value else { return }
                chosenCryptoRates.append(readValue)
                    
                guard let readPreviousRates = result.previous else { return }
                chosenCryptoPreviousRates.append(readPreviousRates)
            }
                
            for name in chosenCryptoNames {

                switch(name) {
                    
                case "BTC-PLN":
                    assignedCryptoNames.append("Bitcoin")
                    assignedCryptoSubNames.append("BTC")
                    assignedCryptoIcon.append("btc")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                    
                case "ETH-PLN":
                    assignedCryptoNames.append("Ethereum")
                    assignedCryptoSubNames.append("ETH")
                    assignedCryptoIcon.append("eth")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                    
                case "LTC-PLN":
                    assignedCryptoNames.append("Litecoin")
                    assignedCryptoSubNames.append("LTC")
                    assignedCryptoIcon.append("ltc")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                    
                case "LSK-PLN":
                    assignedCryptoNames.append("Lisk")
                    assignedCryptoSubNames.append("LSK")
                    assignedCryptoIcon.append("lsk")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                    
                case "TRX-PLN":
                    assignedCryptoNames.append("Tron")
                    assignedCryptoSubNames.append("TRX")
                    assignedCryptoIcon.append("trx")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                    
                case "AMLT-PLN":
                    assignedCryptoNames.append("AMLT")
                    assignedCryptoSubNames.append("AMLT")
                    assignedCryptoIcon.append("amlt")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                    
                case "NEU-PLN":
                    assignedCryptoNames.append("Neumark")
                    assignedCryptoSubNames.append("NEU")
                    assignedCryptoIcon.append("neu")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)

                case "BOB-PLN":
                    assignedCryptoNames.append("Bobs repair")
                    assignedCryptoSubNames.append("BOB")
                    assignedCryptoIcon.append("bob")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                    
                case "GNT-PLN":
                    assignedCryptoNames.append("GNT")
                    assignedCryptoSubNames.append("GNT")
                    assignedCryptoIcon.append("bob")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                    
                default:
                    assignedCryptoNames.append("Ripple")
                    assignedCryptoSubNames.append("XRP")
                    assignedCryptoIcon.append("xrp")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    percentColors.append(.clear)
                }
            }
            
            DispatchQueue.main.async {
                
                self.initObjects.mainTableView.reloadData()
            }
        } catch {
            print("Could not retrive data")
        }
    }
    
    func percentageValue(rate: String, previousRate: String, index: Int) -> String {
          
        let percentValue = (previousRate as NSString).doubleValue * 100 / (rate as NSString).doubleValue
        percentResult = 100 - percentValue
          
        if percentResult < 0.0 {
            percentResult = percentResult * (-1)
            percentColors.insert(.red, at: index)
        } else {
            percentColors.insert(.green, at: index)
        }
          
        return String(format: "%.2f", percentResult)
    }
    
    func deleteData(index: IndexPath) {
               
        let context = persistence.context
               
        let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
               
        fetchRequest.predicate = NSPredicate(format: "title = %@", chosenCryptoNames[index.row])
        fetchRequest.predicate = NSPredicate(format: "value = %@", chosenCryptoRates[index.row])
        fetchRequest.predicate = NSPredicate(format: "previous = %@", chosenCryptoPreviousRates[index.row])

        do {
            
            if let result = try? context.fetch(fetchRequest) {
                for object in result {
                    context.delete(object)
                    chosenCryptoNames.remove(at: index.row)
                    chosenCryptoRates.remove(at: index.row)
                    chosenCryptoPreviousRates.remove(at: index.row)
                    initObjects.mainTableView.deleteRows(at: [index], with: .middle)
                    initObjects.mainTableView.reloadData()
                }
            }

            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

extension ChosenCryptocurrencyViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return chosenCryptoNames.count//cryptocurrencyName.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        guard let cell = initObjects.mainTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MainCell else { return UITableViewCell() }

        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: MainCell, indexPath: IndexPath) {

        cell.textLabel?.text = assignedCryptoNames[indexPath.row]
        cell.detailTextLabel?.text = assignedCryptoSubNames[indexPath.row]
        cell.cryptoValueLabel.text = "\(chosenCryptoRates[indexPath.row])  PLN"
        //cell.textLabel?.text = cryptocurrencyName[indexPath.row]
        //cell.detailTextLabel?.text = cryptocurrencyRate[indexPath.row]
        //cell.cryptoValueLabel.text = "\(cryptocurrencyPreviousRate[indexPath.row])  PLN"
        cell.upArrowImage.tintColor = percentColors[indexPath.row]
        cell.cryptoSubValueLabel.textColor = percentColors[indexPath.row]
        //cell.cryptoSubValueLabel.text = "\(value3[indexPath.row]) %"
        cell.cryptoSubValueLabel.text = "\(assignedCryptoPreviousRates[indexPath.row]) %"
    }
}

extension ChosenCryptocurrencyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //deleteData(index: indexPath)
        coordinator?.detailView(name: chosenCryptoNames[indexPath.row], rate: chosenCryptoRates[indexPath.row])
       // coordinator?.detailView(name: assignedCryptoNames[indexPath.row], rate: chosenCryptoRates[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}


/*   */

//nalezaloby zapewnic nadpisywanie zapisanych danych, gdyz wystepuje tu blad, iz
//czasami na ulamek sekundy wybrane kryptowaluty maja wczesniejsze wartosci...
/*func updateData(title: String, value: String, previousRate: String) {
    
    /*let context = persistence.context
         
    let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
    
    fetchRequest.predicate = NSPredicate(format: "title = %@", title as CVarArg)
    fetchRequest.predicate = NSPredicate(format: "value = %@", value)
    fetchRequest.predicate = NSPredicate(format: "previous = %@", previousRate as CVarArg)
    
    do {
        let result = try context.fetch(fetchRequest)
        for object in result {
            object.setValue(title, forKey: "title")
            object.setValue(value, forKey: "value")
            object.setValue(previousRate, forKey: "previous")
            //print(object)
            //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }
       do {
            try context.save()
        } catch {
            print("Saving error")
        }
        
    } catch {
        print(error)
    }*/
}*/
