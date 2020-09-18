//
//  CryptoViewModel.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

//chodzi o to, by cala logika biznesowa zostala przerzucona do tego pliku
//w ViewControllerze ma zostac tylko:
//extension do UITableViewDelegate i DataSource(ale tez ze zmienionymi przypisami do np. cell.textLabel?.text = (...)
//IBActions
//viewDidLoad i loadView a w nich setupView oraz polaczenie z widokiem

import UIKit

class CryptoViewModel {
    
   /* let name: String = ""
    var jsonObjectsList: [Crypto]?
    let initObjects = MainView()
    
    let networking = Networking.shared
    let persistence = Persistence.shared
    
    //var cryptoNames = [""]
    private var cryptoRates = [""]
    var chosenCryptoNames: [String] = []
    var chosenCryptoRates: [String] = []
    var cryptoPreviousRates = [""]
    var assignedCryptoPreviousRates: [String] = []
    
    var percentColors: [UIColor] = []
    var percentResult = 0.0
    
    //DI - Dependency Injection
   // init(crypto: Crypto) {
        //self.name = name
   // }
    
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
    }*/
}
