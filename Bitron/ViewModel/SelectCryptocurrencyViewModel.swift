//
//  SelectCryptocurrencyViewModel.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/17/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class SelectCryptocurrencyViewModel {
    
    //MARK: - Properties
    private var persistence = Persistence.shared
    private var storedCryptocurrencyCoreData: [String] = []
    private var filteredData: [String] = []
    var cryptocurrencyShortNames: [String] = []
    var cryptocurrencyNames: [String] = []
    var cryptocurrencySortedNames: [String] = []
    var cryptocurrencySubNames : [String] = []
    var cryptocurrencyRates: [String] = []
    var cryptocurrencyPreviousRates: [String] = []
    var cryptocurrencyIcon: [String] = []
    
    // MARK: - internal
    func getJSONUsingBitbayAPI(completion: @escaping () -> Void) {
        Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { (response) in
           
            switch response.result {
            case .success(let value):
                let jsonValue = JSON(value)

                self.cryptocurrencySortedNames = ["ZRX-PLN", "ALG-PLN", "AMLT-PLN", "REP-PLN", "BAT-PLN", "BTC-PLN", "BCC-PLN", "BTG-PLN", "BSV-PLN", "BCP-PLN", "BOB-PLN", "LINK-PLN", "DASH-PLN", "ETH-PLN", "EXY-PLN", "GAME-PLN", "GNT-PLN", "XIN-PLN", "LSK-PLN", "LML-PLN", "LTC-PLN", "MKR-PLN", "NEU-PLN", "OMG-PLN", "XRP-PLN", "XLM-PLN", "PAY-PLN", "TRX-PLN", "ZEC-PLN"]

                self.cryptocurrencySubNames = ["ZRX", "ALG", "AMLT", "REP", "BAT", "BTC", "BCC", "BTG", "BSV", "BCP", "BOB", "LINK", "DASH", "ETH", "EXY", "GAME", "GNT", "XIN", "LSK", "LML", "LTC", "MKR", "NEU", "OMG", "XRP", "XLM", "PAY", "TRX", "ZEC"]
                
                self.cryptocurrencyIcon = ["zrx", "btc", "amlt", "rep", "bat", "btc", "bcc", "btg", "bsv", "btc", "bob", "link", "dash", "eth", "btc", "game", "gnt", "xin", "lsk", "btc", "ltc", "mkr", "neu", "omg", "xrp", "btc", "pay", "trx", "zec"]
                
                for items in self.cryptocurrencySortedNames {
                    let json = JSON(jsonValue)["items"][items]
                    var cryptocurrency = SelectCryptocurrency(json: json)
                    cryptocurrency.name = items
                    self.cryptocurrencyNames.append(Constants.settingMainNameOfCryptocurrency(getName: items))
                    let fetchedCryptocurrencyRatesString = cryptocurrency.rate
                    let fetchedCryptocurrencyRatesfloatValue = Float(fetchedCryptocurrencyRatesString ?? "")
                    self.cryptocurrencyRates.append(String(format: "%.2f", fetchedCryptocurrencyRatesfloatValue ?? ""))            
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
        let icon = cryptocurrencyIcon[indexPath.row]
        let storedCryptocurrencyCoreData = self.persistence.retriveCoreData()
        let filterData = Array(NSOrderedSet(array: storedCryptocurrencyCoreData.name))
        
        filteredData = filterData.map { ($0 as? String ?? "") }
            
        if !filteredData.contains(name) {
            persistence.createCoreData(title: name, value: rate, previousRate: previousRate, image: icon)
        }
    }
}
