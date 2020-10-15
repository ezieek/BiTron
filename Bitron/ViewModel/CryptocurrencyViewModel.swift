//
//  CryptocurrencyViewModel.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/17/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class CryptocurrencyViewModel {
    
    private var storedCryptocurrencyCoreData: [String] = []
    private var filteredData: [String] = []
    private var persistence = Persistence.shared
    var cryptocurrencyShortNames: [String] = []
    var cryptocurrencyNames: [String] = []
    var cryptocurrencySortedNames: [String] = []
    var cryptocurrencyRates: [String] = []
    var cryptocurrencyPreviousRates: [String] = []
    var cryptocurrencyIcon: [String] = []
    
    private func retriveCoreData() {
            
        let context = persistence.context
            
        let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
            
        do {
            let results = try context.fetch(fetchRequest)
                    
            for result in results {
                
                guard let readTitle = result.title else { return }
                storedCryptocurrencyCoreData.append(readTitle)
            }
            
        } catch {
            print("Could not retrive data")
        }
    }
    
    func getJSONUsingBitbayAPI(completion: @escaping () -> Void) {
    
        Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { (response) in
           
            switch response.result {
                
            case .success(let value):
                    
                let jsonValue = JSON(value)

                self.cryptocurrencySortedNames = ["ZRX-PLN", "ALG-PLN", "AMLT-PLN", "REP-PLN", "BAT-PLN", "BTC-PLN", "BCC-PLN", "BTG-PLN", "BSV-PLN", "BCP-PLN", "BOB-PLN", "LINK-PLN", "DASH-PLN", "ETH-PLN", "EXY-PLN", "GAME-PLN", "GNT-PLN", "XIN-PLN", "LSK-PLN", "LML-PLN", "LTC-PLN", "MKR-PLN", "NEU-PLN", "OMG-PLN", "XRP-PLN", "XLM-PLN", "PAY-PLN", "TRX-PLN", "ZEC-PLN"]
                
                self.cryptocurrencyIcon = ["zrx", "btc", "amlt", "rep", "bat", "btc", "bcc", "btg", "bsv", "btc", "bob", "link", "dash", "eth", "btc", "game", "gnt", "xin", "lsk", "btc", "ltc", "mkr", "neu", "omg", "xrp", "btc", "pay", "trx", "zec"]
                
                for items in self.cryptocurrencySortedNames {
                    
                    let json = JSON(jsonValue)["items"][items]
                    var cryptocurrency = Cryptocurrency(json: json)
                    cryptocurrency.name = items
                    
                    self.cryptocurrencyNames.append(self.settingTheMainNameOfCryptocurrency(getName: items))
                    self.cryptocurrencyRates.append(cryptocurrency.rate ?? "")
                    self.cryptocurrencyPreviousRates.append(cryptocurrency.previousRate ?? "")
                }
                
                completion()

            case .failure(let error):
                   print(error)
            }
        }
    }
    
    func pushDataToFavoritesViewController(indexPath: NSIndexPath) {
        
        let name = cryptocurrencySortedNames[indexPath.row]
        let rate = cryptocurrencyRates[indexPath.row]
        let previousRate = cryptocurrencyPreviousRates[indexPath.row]
        
        retriveCoreData()
            
        let filterData = Array(NSOrderedSet(array: storedCryptocurrencyCoreData))
            
        filteredData = filterData.map { ($0 as? String ?? "") }
            
        if !filteredData.contains(name) {
            createCoreData(title: name, value: rate, previousRate: previousRate)
        }
    }
    
    private func createCoreData(title: String, value: String, previousRate: String) {
            
        let context = persistence.context
        
        guard let userEntity = NSEntityDescription.entity(forEntityName: "CryptocurrencyModel", in: context) else { return }
             
        let newValue = NSManagedObject(entity: userEntity, insertInto: context)
        newValue.setValue(title, forKey: "title")
        newValue.setValue(value, forKey: "value")
        newValue.setValue(previousRate, forKey: "previous")
        
        do {
            try context.save()
        } catch {
            print("Saving error")
        }
    }
    
    private func settingTheMainNameOfCryptocurrency(getName: String) -> String {
        
        var nameReceived: String = ""
        
        switch(getName) {
        
        case "XLM-PLN":
            nameReceived = "Stellar"
            
        case "BTC-PLN":
            nameReceived = "Bitcoin"
            
        case "BCC-PLN":
            nameReceived = "Bitcoin Cash"

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
