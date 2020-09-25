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

    weak var coordinator: ApplicationCoordinator?
    let initObjects = DetailView()
    let colors = Colors()
    let networking = Networking.shared
    let persistence = Persistence.shared
    
    var pushedCryptocurrencyName: String = ""
    var pushedCryptocurrencySubName: String = ""
    var pushedCryptocurrencyRate: String = ""
    var pushedCryptocurrencyPreviousRate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
       // retriveCoreData()
       // parseJSONData()
    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
    }
    
    func setupView() {
        
        navigationItem.title = pushedCryptocurrencyName
        initObjects.nameLabel.text = pushedCryptocurrencyRate
        view.layer.insertSublayer(colors.gradientColor, at: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .done, target: self, action: #selector(backButtonPressed))
        initObjects.pushNotificationButton.addTarget(self, action: #selector(deleteDataButtonPressed), for: .touchUpInside)
    }
    
    @objc func deleteDataButtonPressed() {
        print(1)
        
           // deleteData()
    }
    
    @objc func backButtonPressed() {
        
        coordinator?.mainView()
    }
    /*
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
                    assignedCryptoIcon.append("btc1")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    
                case "ETH-PLN":
                    assignedCryptoNames.append("Ethereum")
                    assignedCryptoSubNames.append("ETH")
                    assignedCryptoIcon.append("eth1")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    
                case "LTC-PLN":
                    assignedCryptoNames.append("Litecoin")
                    assignedCryptoSubNames.append("LTC")
                    assignedCryptoIcon.append("ltc")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    
                case "LSK-PLN":
                    assignedCryptoNames.append("Lisk")
                    assignedCryptoSubNames.append("LSK")
                    assignedCryptoIcon.append("lsk")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    
                case "ALG-PLN":
                    assignedCryptoNames.append("Algory")
                    assignedCryptoSubNames.append("ALG")
                    assignedCryptoIcon.append("bitcoin")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    
                case "TRX-PLN":
                    assignedCryptoNames.append("Tron")
                    assignedCryptoSubNames.append("TRX")
                    assignedCryptoIcon.append("trx")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    
                case "AMLT-PLN":
                    assignedCryptoNames.append("AMLT")
                    assignedCryptoSubNames.append("AMLT")
                    assignedCryptoIcon.append("amlt")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    
                case "NEU-PLN":
                    assignedCryptoNames.append("Neumark")
                    assignedCryptoSubNames.append("NEU")
                    assignedCryptoIcon.append("neu")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)

                case "BOB-PLN":
                    assignedCryptoNames.append("Bobs repair")
                    assignedCryptoSubNames.append("BOB")
                    assignedCryptoIcon.append("bob")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                    
                default:
                    assignedCryptoNames.append("Ripple")
                    assignedCryptoSubNames.append("XRP")
                    assignedCryptoIcon.append("xrp")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptoPreviousRates)
                }
            }
            
            //DispatchQueue.main.async {
                
                //self.initObjects.mainTableView.reloadData()
            //}
                
        } catch {
            print("Could not retrive data")
        }
    }*/
    /*
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
                            
                    self?.name = self?.chosenCryptocurrencyName ?? ""
                        
                    DispatchQueue.main.async {
                            
                        switch(self?.name) {
                                
                            case "BTC-PLN":
                                let btcRate = response.items.btc.rate
                                let btcPreviousRate = response.items.btc.previousRate
                                self?.initObjects.rateLabel.text = btcRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: btcRate, previousRate: btcPreviousRate, index: currentIndex) ?? "")

                            case "ETH-PLN":
                                let ethRate = response.items.eth.rate
                                let ethPreviousRate = response.items.eth.previousRate
                                self?.initObjects.rateLabel.text = ethRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: ethRate, previousRate: ethPreviousRate, index: currentIndex) ?? "")

                            case "LTC-PLN":
                                let ltcRate = response.items.ltc.rate
                                let ltcPreviousRate = response.items.ltc.previousRate
                                self?.initObjects.rateLabel.text = ltcRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: ltcRate, previousRate: ltcPreviousRate, index: currentIndex) ?? "")

                            case "LSK-PLN":
                                let lskRate = response.items.lsk.rate
                                let lskPreviousRate = response.items.lsk.previousRate
                                self?.initObjects.rateLabel.text = lskRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: lskRate, previousRate: lskPreviousRate, index: currentIndex) ?? "")

                            case "TRX-PLN":
                                let trxRate = response.items.trx.rate
                                let trxPreviousRate = response.items.trx.previousRate
                                self?.initObjects.rateLabel.text = trxRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: trxRate, previousRate: trxPreviousRate, index: currentIndex) ?? "")
                                
                            case "AMLT-PLN":
                                let amltRate = response.items.amlt.rate
                                let amltPreviousRate = response.items.amlt.previousRate
                                self?.initObjects.rateLabel.text = amltRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: amltRate, previousRate: amltPreviousRate, index: currentIndex) ?? "")
                                
                            case "NEU-PLN":
                                let neuRate = response.items.neu.rate
                                let neuPreviousRate = response.items.neu.previousRate
                                self?.initObjects.rateLabel.text = neuRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: neuRate, previousRate: neuPreviousRate, index: currentIndex) ?? "")
                                
                            case "BOB-PLN":
                                let bobRate = response.items.bob.rate
                                let bobPreviousRate = response.items.bob.previousRate
                                self?.initObjects.rateLabel.text = bobRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: bobRate, previousRate: bobPreviousRate, index: currentIndex) ?? "")
                                
                            default:
                                let xrpRate = response.items.xrp.rate
                                let xrpPreviousRate = response.items.xrp.previousRate
                                self?.initObjects.rateLabel.text = xrpRate
                                self?.initObjects.percentageRateLabel.text = String(self?.percentageValue(rate: xrpRate, previousRate: xrpPreviousRate, index: currentIndex) ?? "")
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
    }*/
    /*
    func percentageValue(rate: String, previousRate: String, index: Int) -> String {
        
        let percentValue = (previousRate as NSString).doubleValue * 100 / (rate as NSString).doubleValue
        percentResult = 100 - percentValue
        
        if percentResult < 0 {
            percentResult = percentResult * (-1)
            initObjects.percentageRateLabel.textColor = .red
        } else {
            initObjects.percentageRateLabel.textColor = .green
        }
        
        return String(format: "%.2f", percentResult)
    }*/
    
    /*  func deleteData(index: IndexPath) {
                 
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
      }*/
    
}
