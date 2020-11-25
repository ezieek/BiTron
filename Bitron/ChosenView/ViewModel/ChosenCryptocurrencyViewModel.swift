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
    private lazy var model: [ChosenCryptocurrencyModel] = [ChosenCryptocurrencyModel]()
    private let persistence = Persistence.shared
    private let constants = Constants.shared
    private lazy var chosenCryptocurrencyNames: [String] = []
    private lazy var chosenCryptocurrencySubNames: [String] = []
    private lazy var chosenCryptocurrencyRates: [String] = []
    private lazy var chosenCryptocurrencyPreviousRates: [String] = []
    private lazy var percentResult = 0.0
    private lazy var percentColors: [UIColor] = []
    private lazy var rate: [String] = []
    private lazy var previousRate: [String] = []
    
    // MARK: - internal
    func getCurrentValue(completion: @escaping([ChosenCryptocurrencyModel]) -> ()) {
        let retrivedCoreData = self.persistence.retriveCoreData()
        let timeInterval = 2.0
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            AF.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in
                switch response.result {
                
                case .success(let value):
                    let jsonValue = JSON(value)
                    
                    for names in retrivedCoreData.name {
                        let json = JSON(jsonValue)["items"][names]
                        self?.rate.append(json["rate"].stringValue)
                        self?.previousRate.append(json["previousRate"].stringValue)
                    }
                    
                    self?.getCoreData()
                    
                case .failure(let error):
                    print(error)
                }
                
                completion(self?.model ?? [])
                self?.cleanChosenCryptocurrencyData()
            }
        })
    }
    
    func turnOffTheCounter() {
        timer?.invalidate()
    }
    
    // MARK: - private
    private func getCoreData() {
        let retrivedCoreData = self.persistence.retriveCoreData()
        for i in 0..<retrivedCoreData.name.count {
            self.chosenCryptocurrencyNames.append(self.constants.settingMainNameOfCryptocurrency(getName: retrivedCoreData.name[i]) )
            
            self.chosenCryptocurrencySubNames.append(retrivedCoreData.name[i].replacingOccurrences(of: "-PLN", with: ""))
            
            let fetchedCryptocurrencyRate = Float(self.rate[i]) ?? 0.0
            self.chosenCryptocurrencyRates.append(String(format: "%.2f", fetchedCryptocurrencyRate))
            
            self.chosenCryptocurrencyPreviousRates.append(self.calculatingThePercentageDifference(
                rate: self.rate[i],
                previousRate: self.previousRate[i]))
            
            self.model.append(ChosenCryptocurrencyModel(
                name: self.chosenCryptocurrencyNames[i],
                subName: self.chosenCryptocurrencySubNames[i],
                rate: self.chosenCryptocurrencyRates[i],
                previousRate: self.chosenCryptocurrencyPreviousRates[i],
                image: retrivedCoreData.image[i],
                color: self.percentColors[i]))
        }
    }
    
    private func cleanChosenCryptocurrencyData() {
        self.rate.removeAll()
        self.previousRate.removeAll()
        self.model.removeAll()
        self.chosenCryptocurrencyNames.removeAll()
        self.chosenCryptocurrencySubNames.removeAll()
        self.chosenCryptocurrencyRates.removeAll()
        self.chosenCryptocurrencyPreviousRates.removeAll()
        self.percentColors.removeAll()
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
