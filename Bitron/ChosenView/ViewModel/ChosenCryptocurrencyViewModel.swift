//
//  ChosenCryptocurrencyViewModel.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/18/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class ChosenCryptocurrencyViewModel {
    
    // MARK: - Properties
    weak var timer: Timer?
    private let persistence = Persistence.shared
    var chosenCryptocurrencyNames: [String] = []
    var chosenCryptocurrencySubNames: [String] = []
    var chosenCryptocurrencyRates: [String] = []
    var chosenCryptocurrencyPreviousRates: [String] = []
    var chosenCryptocurrencyImages: [String] = []
    var percentResult = 0.0
    var percentColors: [UIColor] = []
    
    // MARK: - internal
    func getCurrentValueOfSavedCryptocurrenciesFirstLoadView(completion: @escaping () -> Void) {
        self.percentColors.removeAll()
        let retrivedCoreData = self.persistence.retriveCoreData()
    
        AF.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in

            switch response.result {
            case .success(let value):
                self?.responseJSON(value: value, cryptocurrencyName: retrivedCoreData.name, cryptocurrencyImage: retrivedCoreData.image)
                completion()
            case .failure(let error):
                print(error)
            }
        }
        self.cleanChosenCryptocurrencyData()
    }

    func getCurrentValueOfSavedCryptocurrenciesNextLoadView(completion: @escaping () -> Void) {
        let timeInterval = 1.0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            
            self.percentColors.removeAll()
            let retrivedCoreData = self.persistence.retriveCoreData()
            
            AF.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in

                switch response.result {
                case .success(let value):
                    self?.responseJSON(value: value, cryptocurrencyName: retrivedCoreData.name, cryptocurrencyImage: retrivedCoreData.image)
                    completion()
                case .failure(let error):
                    print(error)
                }
            }
            self.cleanChosenCryptocurrencyData()
        })
    }
    
    func turnOffTheCounter() {
        timer?.invalidate()
    }
    
    // MARK: - private
    private func responseJSON(value: Any, cryptocurrencyName: [String], cryptocurrencyImage: [String]) {
        let jsonValue = JSON(value)
        
        for names in cryptocurrencyName {
            let json = JSON(jsonValue)["items"][names]
            let cryptocurrency = SelectCryptocurrencyModel(json: json)
            let removingUselessString = names.replacingOccurrences(of: "-PLN", with: "")
            let fetchedCryptocurrencyRatesString = cryptocurrency.rate ?? ""
            let fetchedCryptocurrencyRatesFloatValue = Float(fetchedCryptocurrencyRatesString)
            
            chosenCryptocurrencyNames.append(Constants.settingMainNameOfCryptocurrency(getName: names))
            chosenCryptocurrencySubNames.append(removingUselessString)
            chosenCryptocurrencyRates.append(String(format: "%.2f", fetchedCryptocurrencyRatesFloatValue ?? ""))
            chosenCryptocurrencyPreviousRates.append(self.calculatingThePercentageDifference(rate: cryptocurrency.rate ?? "", previousRate: cryptocurrency.previousRate ?? ""))
            chosenCryptocurrencyImages.append(contentsOf: cryptocurrencyImage)
        }
    }
    
    private func cleanChosenCryptocurrencyData() {
        chosenCryptocurrencyNames.removeAll()
        chosenCryptocurrencySubNames.removeAll()
        chosenCryptocurrencyRates.removeAll()
        chosenCryptocurrencyPreviousRates.removeAll()
        chosenCryptocurrencyImages.removeAll()
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
