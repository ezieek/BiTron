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
    
    private var cryptocurrencyNames: [String] = []
    private var cryptocurrencyRates: [String] = []
    private var cryptocurrencyPreviousRates: [String] = []
    private var storedCryptocurrencyCoreData: [String] = []
    private var filteredData: [String] = []
    private var persistence = Persistence.shared
    
    func getJSON(completion: @escaping ((_ names: [String], _ rates: [String], _ previousRates: [String]) -> Void)) {
    
        Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { (response) in
           
            switch response.result {
            
                case .success(let value):
                    
                    let jsonValue = JSON(value)
                    
                    //searching for every available cryptocurrencies in PLN
                    for (_, subJson):(String, JSON) in jsonValue {
                        for(key,_):(String, JSON) in subJson {
                            
                            let subString = "-PLN"
                            if key.contains(subString) {
                                self.cryptocurrencyNames.append(key)
                            }
                        }
                    }
                    
                    for items in self.cryptocurrencyNames {
                        
                        let json = JSON(jsonValue)["items"][items]
                        var cryptocurrency = Cryptocurrency(json: json)
                        cryptocurrency.name = items
                        
                        self.cryptocurrencyRates.append(cryptocurrency.rate ?? "")
                        self.cryptocurrencyPreviousRates.append(cryptocurrency.previousRate ?? "")
                    }
                    
                    completion(self.cryptocurrencyNames, self.cryptocurrencyRates, self.cryptocurrencyPreviousRates)

                case .failure(let error):
                   print(error)
            }
        }
    }
    
    func pushData(index: NSIndexPath) {
        
        let name = cryptocurrencyNames[index.row]
        let rate = cryptocurrencyRates[index.row]
        let previousRate = cryptocurrencyPreviousRates[index.row]
        
        retriveCoreData()
            
        let filterData = Array(NSOrderedSet(array: storedCryptocurrencyCoreData))
            
        filteredData = filterData.map { ($0 as? String ?? "") }
            
        if !filteredData.contains(name) {
            createCoreData(title: name, value: rate, previousRate: previousRate)
        }
    }
    
    func createCoreData(title: String, value: String, previousRate: String) {
            
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
        
    func retriveCoreData() {
            
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
}
