//
//  FavoritesCryptocurrencyViewModel.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/18/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class FavoritesCryptocurrencyViewModel {
    
    private let persistence = Persistence.shared
    private var chosenCryptocurrencyNames: [String] = []
    private var chosenCryptocurrencyRates: [String] = []
    private var chosenCryptocurrencyPreviousRates: [String] = []
    private var assignedCryptoNames: [String] = []
    private var assignedCryptoSubNames: [String] = []
    private var assignedCryptoIcon: [String] = []
    private var assignedCryptoPreviousRates: [String] = []
    private var percentColors: [UIColor] = []
    private var percentResult = 0.0

    func getJSON() {

        Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { (response) in
            
            switch response.result {
            
            case .success(let value):
                
                let jsonValue = JSON(value)
                    
                //searching for every available cryptocurrencies in PLN
                for (_, subJson):(String, JSON) in jsonValue {
                    for(key,_):(String, JSON) in subJson {
                            
                        let subString = "-PLN"
                        if key.contains(subString) {
                            print(key)
                            self.chosenCryptocurrencyNames.append(key)
                        }
                        
                        /*for items in self.chosenCryptocurrencyNames {
                            
                            let json = JSON(jsonValue)["items"][items]
                            var cryptocurrency = Cryptocurrency(json: json)
                            cryptocurrency.name = items
                            
                        }*/
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        
       /* DispatchQueue.main.async {
                
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
        }*/
    }
    
    func retriveCoreData(completion: @escaping ((_ names: [String], _ rates: [String], _ previousRates: [String]) -> Void)) {
            
        let context = persistence.context
            
        let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
                
        do {
            let results = try context.fetch(fetchRequest)
                    
            for result in results {
                    
                guard let readTitle = result.title else { return }
                chosenCryptocurrencyNames.append(readTitle)
                    
                guard let readValue = result.value else { return }
                chosenCryptocurrencyRates.append(readValue)
                    
                guard let readPreviousRates = result.previous else { return }
                chosenCryptocurrencyPreviousRates.append(readPreviousRates)
            }
                
            for name in chosenCryptocurrencyNames {

                switch(name) {
                    
                case "BTC-PLN":
                    assignedCryptoNames.append("Bitcoin")
                    assignedCryptoSubNames.append("BTC")
                    assignedCryptoIcon.append("btc")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                    
                case "ETH-PLN":
                    assignedCryptoNames.append("Ethereum")
                    assignedCryptoSubNames.append("ETH")
                    assignedCryptoIcon.append("eth")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                    
                case "LTC-PLN":
                    assignedCryptoNames.append("Litecoin")
                    assignedCryptoSubNames.append("LTC")
                    assignedCryptoIcon.append("ltc")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                    
                case "LSK-PLN":
                    assignedCryptoNames.append("Lisk")
                    assignedCryptoSubNames.append("LSK")
                    assignedCryptoIcon.append("lsk")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                    
                case "TRX-PLN":
                    assignedCryptoNames.append("Tron")
                    assignedCryptoSubNames.append("TRX")
                    assignedCryptoIcon.append("trx")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                    
                case "AMLT-PLN":
                    assignedCryptoNames.append("AMLT")
                    assignedCryptoSubNames.append("AMLT")
                    assignedCryptoIcon.append("amlt")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                    
                case "NEU-PLN":
                    assignedCryptoNames.append("Neumark")
                    assignedCryptoSubNames.append("NEU")
                    assignedCryptoIcon.append("neu")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)

                case "BOB-PLN":
                    assignedCryptoNames.append("Bobs repair")
                    assignedCryptoSubNames.append("BOB")
                    assignedCryptoIcon.append("bob")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                    
                case "GNT-PLN":
                    assignedCryptoNames.append("GNT")
                    assignedCryptoSubNames.append("GNT")
                    assignedCryptoIcon.append("bob")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                    
                default:
                    assignedCryptoNames.append("Ripple")
                    assignedCryptoSubNames.append("XRP")
                    assignedCryptoIcon.append("xrp")
                    assignedCryptoPreviousRates.append(contentsOf: chosenCryptocurrencyPreviousRates)
                    percentColors.append(.clear)
                }
            }
            
            completion(assignedCryptoNames, assignedCryptoSubNames, assignedCryptoPreviousRates)
            
        } catch {
            print("Could not retrive data")
        }
    }
}
