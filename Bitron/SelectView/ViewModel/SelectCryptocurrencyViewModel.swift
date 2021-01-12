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
    
    // MARK: - Properties
    private lazy var persistence = Persistence.shared
    private lazy var constants = Constants.shared
    private lazy var model: [SelectCryptocurrencyModel] = [SelectCryptocurrencyModel]()
    private lazy var selectCryptocurrencyName: [String] = []
    private lazy var selectCryptocurrencyShortName: [String] = []
    private lazy var selectCryptocurrencyRate: [String] = []
    private lazy var selectCryptocurrencyPreviousRate: [String] = []
    private lazy var rate: [String] = []
    private lazy var previousRate: [String] = []
    private lazy var filteredData: [String] = []
    private lazy var storedCryptocurrencyCoreData: [String] = []

    private lazy var selectCryptocurrencySortedName = ["ZRX-PLN", "ALG-PLN", "AMLT-PLN", "REP-PLN", "BAT-PLN", "BTC-PLN", "BCC-PLN", "BTG-PLN", "BSV-PLN", "BCP-PLN", "BOB-PLN", "LINK-PLN", "DASH-PLN", "ETH-PLN", "EXY-PLN", "GAME-PLN", "GNT-PLN", "XIN-PLN", "LSK-PLN", "LML-PLN", "LTC-PLN", "MKR-PLN", "NEU-PLN", "OMG-PLN", "XRP-PLN", "XLM-PLN", "PAY-PLN", "TRX-PLN", "ZEC-PLN"]
    
    private lazy var selectCryptocurrencyImage = ["zrx", "btc", "amlt", "rep", "bat", "btc-1", "bcc", "btg", "bsv", "btc-2", "bob", "link", "dash", "eth", "btc-3", "game", "gnt", "xin", "lsk", "btc-4", "ltc", "mkr", "neu", "omg", "xrp", "btc-5", "pay", "trx", "zec"]
    
    // MARK: - internal
    func getJSON(completion: @escaping([SelectCryptocurrencyModel]) -> Void) {
        AF.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { (response) in
            switch response.result {
            
            case .success(let value):
                let jsonValue = JSON(value)
                
                for names in self.selectCryptocurrencySortedName {
                    let json = JSON(jsonValue)["items"][names]
                    self.rate.append(json["rate"].stringValue)
                    self.previousRate.append(json["previousRate"].stringValue)
                }
                    
                for number in 0..<self.selectCryptocurrencySortedName.count {
                    self.selectCryptocurrencyName.append(self.constants.settingMainNameOfCryptocurrency(getName: self.selectCryptocurrencySortedName[number]))
                   
                    let fetchedCryptocurrencyRate = Float(self.rate[number]) ?? 0.0
                    self.selectCryptocurrencyRate.append(String(format: "%.2f", fetchedCryptocurrencyRate))

                    self.selectCryptocurrencyPreviousRate.append(self.previousRate[number])

                    self.model.append(SelectCryptocurrencyModel(
                        name: self.selectCryptocurrencyName[number],
                        rate: self.selectCryptocurrencyRate[number],
                        image: self.selectCryptocurrencyImage[number]))
                }
                    
            case .failure(let error):
                print(error)
            }
            
            completion(self.model)
            self.model.removeAll()
        }
    }
    
    func saveCryptocurrencyData(indexPath: IndexPath) {
        let name = selectCryptocurrencySortedName[indexPath.row]
        let rate = selectCryptocurrencyRate[indexPath.row]
        let previousRate = selectCryptocurrencyPreviousRate[indexPath.row]
        let icon = selectCryptocurrencyImage[indexPath.row]
        let storedCryptocurrencyCoreData = self.persistence.retriveCoreData()
        let filterData = Array(NSOrderedSet(array: storedCryptocurrencyCoreData.name))
        
        filteredData = filterData.map { ($0 as? String ?? "") }
            
        if !filteredData.contains(name) {
            persistence.createCoreData(name: name, rate: rate, previousRate: previousRate, image: icon)
        }
    }
}
