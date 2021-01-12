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
    var rate: [String] = []
    var previousRate: [String] = []
    
    // MARK: - internal
    func getCurrentValue(completion: @escaping([ChosenCryptocurrencyModel]) -> Void) {
        let timeInterval = 1.0
        let retrivedCoreData = self.persistence.retriveCoreData()
        let name = retrivedCoreData.name
 
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            AF.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in

                switch response.result {

                case .success(let value):
                    let jsonValue = JSON(value)
                    for names in name {
                        let json = JSON(jsonValue)["items"][names]
                        self?.rate.append(json["rate"].stringValue)
                        self?.previousRate.append(json["previousRate"].stringValue)
                    }

                    self?.getCoreData()
                    completion(self?.model ?? [])
                    
                case .failure(let error):
                    print(error)
                }
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
        let name = retrivedCoreData.name
        let image = retrivedCoreData.image

        for number in 0..<name.count {
        self.chosenCryptocurrencyNames.append(self.constants.settingMainNameOfCryptocurrency(getName: name[number]))
        self.chosenCryptocurrencySubNames.append(name[number].replacingOccurrences(of: "-PLN", with: ""))
        self.chosenCryptocurrencyRates.append(String(format: "%.2f", Float(rate[number]) ?? 0.0))
            
        self.chosenCryptocurrencyPreviousRates.append(self.calculatingThePercentageDifference(
            rate: rate[number],
            previousRate: previousRate[number]))
            
        self.model.append(ChosenCryptocurrencyModel(
            name: self.chosenCryptocurrencyNames[number],
            subName: self.chosenCryptocurrencySubNames[number],
            rate: self.chosenCryptocurrencyRates[number],
            previousRate: self.chosenCryptocurrencyPreviousRates[number],
            image: image[number],
            color: self.percentColors[number]))
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
            percentResult *= /*percentResult * */(-1)
            percentColors.append(.red)
        }
        
        return String(format: "%.2f", percentResult)
    }
}
