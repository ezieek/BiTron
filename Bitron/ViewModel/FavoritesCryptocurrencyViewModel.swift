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
}
