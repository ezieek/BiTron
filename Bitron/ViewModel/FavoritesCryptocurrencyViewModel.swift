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
    private var assignedCryptoRates: [String] = []
    private var assignedCryptoPreviousRates: [String] = []
    private var percentResult = 0.0
    var percentColors: [UIColor] = []
    
    func retriveCoreData() {
        
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
            
        } catch {
            print("Could not retrive data")
        }
    }
    
    func getCurrentValueOfSavedCryptocurrencies(completion: @escaping (_ name: [String], _ subName: [String], _ rate: [String], _ previousRate: [String]) -> Void) {
            
        retriveCoreData()
        
        Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { (response) in
            
            switch response.result {
            
            case .success(let value):

                let jsonValue = JSON(value)
                var arrayCryptocurrenyNames: [String] = []
                var arrayCryptocurrencySubNames: [String] = []
                var arrayCryptocurrencyRates: [String] = []
                var arrayCryptocurrencyPreviousRate: [String] = []
                
                for names in self.chosenCryptocurrencyNames {

                    let json = JSON(jsonValue)["items"][names]
                    let cryptocurrency = Cryptocurrency(json: json)
                    let removingUselessString = names.replacingOccurrences(of: "-PLN", with: "")
                    
                    arrayCryptocurrenyNames.append(self.settingTheMainNameOfCryptocurrency(getName: names))
                    arrayCryptocurrencySubNames.append(removingUselessString)
                    arrayCryptocurrencyRates.append(cryptocurrency.rate ?? "")
                    arrayCryptocurrencyPreviousRate.append(self.calculatingThePercentageDifference(rate: cryptocurrency.rate ?? "", previousRate: cryptocurrency.previousRate ?? ""))
                }
                    
                for i in 0...arrayCryptocurrenyNames.count - 1 {
                        
                    switch(arrayCryptocurrenyNames[i]) {
                    
                    case arrayCryptocurrenyNames[i]:
                        self.assignedCryptoNames.append(arrayCryptocurrenyNames[i])
                        
                    default:
                        print("There is an problem in Cryptocurrencies Names!")
                    }
                    
                    switch(arrayCryptocurrencySubNames[i]) {
                    
                    case arrayCryptocurrencySubNames[i]:
                        self.assignedCryptoSubNames.append(arrayCryptocurrencySubNames[i])
                        
                    default:
                        print("There is an problem in Cryptocurrencies SubNames!")
                    }
                
                    switch(arrayCryptocurrencyRates[i]) {
                    
                    case arrayCryptocurrencyRates[i]:
                        self.assignedCryptoRates.append(arrayCryptocurrencyRates[i])
                        
                    default:
                        print("There is an problem in Cryptocurrencies Rates!")
                    }
                    
                    switch(arrayCryptocurrencyPreviousRate[i]) {
                    
                    case arrayCryptocurrencyPreviousRate[i]:
                        self.assignedCryptoPreviousRates.append(arrayCryptocurrencyPreviousRate[i])
                        
                    default:
                        print("There is an problem in Cryptocurrencies Previous Rates!")
                    }
                }
                
                completion(self.assignedCryptoNames, self.assignedCryptoSubNames, self.assignedCryptoRates, self.assignedCryptoPreviousRates)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //gdy dana wartosc (Rate) zostanie zmieniony to nalezy ja od razu zapisac do pamieci telefonu
    /*func updateData(title: String, value: String, previousRate: String) {
        
        let context = persistence.context
             
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
        }
    }*/

    private func calculatingThePercentageDifference(rate: String, previousRate: String) -> String {
          
        let percentValue = (previousRate as NSString).doubleValue * 100 / (rate as NSString).doubleValue
        percentResult = 100 - percentValue
          
        if percentResult < 0.0 {
            percentResult = percentResult * (-1)
            percentColors.append(.red)
        } else {
            percentColors.append(.green)
        }
        
        return String(format: "%.2f", percentResult)
    }
    
    private func settingTheMainNameOfCryptocurrency(getName: String) -> String {
        
        var nameReceived: String = ""
        
        switch(getName) {
        
        case "XLM-PLN":
            nameReceived = "Stellar"
            
        case "BTC-PLN":
            nameReceived = "Bitcoin"

        case "NEU-PLN":
            nameReceived = "Neumark"

        case "BCP-PLN":
            nameReceived = "Blockchain Poland"
            
        case "EXY-PLN":
            nameReceived = "Experty"
            
        case "LML-PLN":
            nameReceived = "Lisk Machine Learning"

        case "BOB-PLN":
            nameReceived = "Bob's Repair"

        case "XIN-PLN":
            nameReceived = "Infinity Economics"
            
        case "BTG-PLN":
            nameReceived = "Bitcoin Gold"
            
        case "AMLT-PLN":
            nameReceived = "AMLT"

        case "MKR-PLN":
            nameReceived = "Maker"

        case "XRP-PLN":
            nameReceived = "Ripple"
            
        case "ZRX-PLN":
            nameReceived = "0x"
            
        case "GNT-PLN":
            nameReceived = "Golem"

        case "LINK-PLN":
            nameReceived = "Chainlink"

        case "LSK-PLN":
            nameReceived = "Lisk"
            
        case "GAME-PLN":
            nameReceived = "Game Credits"
            
        case "LTC-PLN":
            nameReceived = "Litecoin"

        case "BAT-PLN":
            nameReceived = "Basic Attention Token"

        case "TRX-PLN":
            nameReceived = "Tron"
            
        case "PAY-PLN":
            nameReceived = "TenX"
            
        case "ZEC-PLN":
            nameReceived = "Zcash"

        case "DASH-PLN":
            nameReceived = "Dash"

        case "OMG-PLN":
            nameReceived = "OmniseGO"
            
        case "ETH-PLN":
            nameReceived = "Ethereum"
            
        case "ALG-PLN":
            nameReceived = "Algory"

        case "BSV-PLN":
            nameReceived = "Bitcoin SV"
            
        case "REP-PLN":
            nameReceived = "Augur"
        
        default:
            nameReceived = "Error!"
            print("There is an problem with that cryptocurrency")
        }
        
        return nameReceived
    }
}
