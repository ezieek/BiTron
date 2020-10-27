//
//  FavoritesCryptocurrencyViewModel.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/18/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class FavoritesCryptocurrencyViewModel {
    
    // MARK: - Properties
    weak var timer: Timer?
    private let persistence = Persistence.shared
    private var chosenCryptocurrencyNames: [String] = []
    private var chosenCryptocurrencyRates: [String] = []
    private var chosenCryptocurrencyPreviousRates: [String] = []
    private var chosenCryptocurrencyImages: [String] = []
    private var percentResult = 0.0
    var percentColors: [UIColor] = []
    var assignedCryptoNames: [String] = []
    var assignedCryptoSubNames: [String] = []
    var assignedCryptoIcon: [String] = []
    var assignedCryptoRates: [String] = []
    var assignedCryptoPreviousRates: [String] = []
    
    // MARK: - internal
    func getCurrentValueOfSavedCryptocurrenciesFirstLoadView(completion: @escaping () -> Void) {
        self.percentColors.removeAll()
        let retrivedCoreData =  self.persistence.retriveCoreData()
        
        Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in
            
            switch response.result {
            case .success(let value):
                self?.responseJSON(value: value, cryptocurrencyName: retrivedCoreData.name, cryptocurrencyImage: retrivedCoreData.image)
                completion()
            case .failure(let error):
                print(error)
            }
        }
        self.cleanAssignedCryptocurrencyData()
    }
    
    func getCurrentValueOfSavedCryptocurrenciesNextLoadView(timeInterval: Double, completion: @escaping () -> Void) {
        self.percentColors.removeAll()
        let retrivedCoreData = self.persistence.retriveCoreData()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] (_) in
            
            Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in

                switch response.result {
                case .success(let value):
                    self?.responseJSON(value: value, cryptocurrencyName: retrivedCoreData.name, cryptocurrencyImage: retrivedCoreData.image)
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
            self?.cleanAssignedCryptocurrencyData()
        })
    }
    
    func turnOffTheCounter() {
        timer?.invalidate()
    }
    
    // MARK: - private
    private func responseJSON(value: Any, cryptocurrencyName: [String], cryptocurrencyImage: [String]) {
        let jsonValue = JSON(value)
        var arrayCryptocurrenyNames: [String] = []
        var arrayCryptocurrencySubNames: [String] = []
        var arrayCryptocurrencyRates: [String] = []
        var arrayCryptocurrencyPreviousRates: [String] = []
        
        for names in cryptocurrencyName {
            let json = JSON(jsonValue)["items"][names]
            let cryptocurrency = Cryptocurrency(json: json)
            let removingUselessString = names.replacingOccurrences(of: "-PLN", with: "")
            arrayCryptocurrenyNames.append(Constants.settingMainNameOfCryptocurrency(getName: names))
            arrayCryptocurrencySubNames.append(removingUselessString)
            arrayCryptocurrencyRates.append(cryptocurrency.rate ?? "")
            arrayCryptocurrencyPreviousRates.append(self.calculatingThePercentageDifference(rate: cryptocurrency.rate ?? "", previousRate: cryptocurrency.previousRate ?? ""))
            self.assignedCryptoIcon = cryptocurrencyImage
        }
    
        for i in 0..<arrayCryptocurrenyNames.count {
            switch(arrayCryptocurrenyNames[i]) {
            case arrayCryptocurrenyNames[i]:
                self.assignedCryptoNames.append(arrayCryptocurrenyNames[i])
            default:
                print("There is a problem with the names of the fetchted cryptocurrencies!")
            }

            switch(arrayCryptocurrencySubNames[i]) {
            case arrayCryptocurrencySubNames[i]:
                self.assignedCryptoSubNames.append(arrayCryptocurrencySubNames[i])
            default:
                print("There is a problem with the subnames of the fetched cryptocurrencies!")
            }
    
            switch(arrayCryptocurrencyRates[i]) {
            case arrayCryptocurrencyRates[i]:
                let fetchedCryptocurrencyRatesString = arrayCryptocurrencyRates[i]
                let fetchedCryptocurrencyRatesfloatValue = Float(fetchedCryptocurrencyRatesString)
                self.assignedCryptoRates.append(String(format: "%.2f", fetchedCryptocurrencyRatesfloatValue ?? ""))
            default:
                print("There is a problem with the rates of the fetched cryptocurrencies!")
            }

            switch(arrayCryptocurrencyPreviousRates[i]) {
            case arrayCryptocurrencyPreviousRates[i]:
                self.assignedCryptoPreviousRates.append(arrayCryptocurrencyPreviousRates[i])
            default:
                print("There is a problem with the previous rates of the fetched cryptocurrencies!")
            }
        }
    }
    
    private func cleanAssignedCryptocurrencyData() {
        assignedCryptoNames.removeAll()
        assignedCryptoSubNames.removeAll()
        assignedCryptoRates.removeAll()
        assignedCryptoPreviousRates.removeAll()
        assignedCryptoIcon.removeAll()
    }

    private func calculatingThePercentageDifference(rate: String, previousRate: String) -> String {
        let percentValue = (previousRate as NSString).doubleValue * 100 / (rate as NSString).doubleValue
        percentResult = 100 - percentValue
          
        if percentResult > 0.0 {
            percentColors.append(.green)
        } else {
            percentResult = percentResult * (-1)
            percentColors.append(.red)
        }
        
        return String(format: "%.2f", percentResult)
    }
}
