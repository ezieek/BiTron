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
    
    weak var timer: Timer?
    private let persistence = Persistence.shared
    private var chosenCryptocurrencyNames: [String] = []
    private var chosenCryptocurrencyRates: [String] = []
    private var chosenCryptocurrencyPreviousRates: [String] = []
    private var chosenCryptocurrencyImage: [String] = []
    private var percentResult = 0.0
    var percentColors: [UIColor] = []
    var assignedCryptoNames: [String] = []
    var assignedCryptoSubNames: [String] = []
    var assignedCryptoIcon: [String] = []
    var assignedCryptoRates: [String] = []
    var assignedCryptoPreviousRates: [String] = []
    
    private func retriveCoreData() {
        
        chosenCryptocurrencyNames.removeAll()
        chosenCryptocurrencyRates.removeAll()
        chosenCryptocurrencyPreviousRates.removeAll()
        chosenCryptocurrencyImage.removeAll()
        
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
                
                guard let readImageName = result.image else { return }
                chosenCryptocurrencyImage.append(readImageName)
            }
        } catch {
            print("Could not retrive core data!")
        }
    }
    
    @objc func getCurrentValueOfSavedCryptocurrenciesFirstLoadView(completion: @escaping () -> Void) {
        
        self.percentColors.removeAll()
        self.retriveCoreData()
        
        Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in
            
            switch response.result {
            
            case .success(let value):
                self?.responseJSON(value: value)
                completion()

            case .failure(let error):
                print(error)
            }
        }
        
        self.assignedCryptoNames.removeAll()
        self.assignedCryptoSubNames.removeAll()
        self.assignedCryptoRates.removeAll()
        self.assignedCryptoPreviousRates.removeAll()
        self.assignedCryptoIcon.removeAll()
    }
    
    @objc func getCurrentValueOfSavedCryptocurrenciesNextLoadView(timeInterval: Double, completion: @escaping () -> Void) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] (_) in
            
            self?.percentColors.removeAll()
            self?.retriveCoreData()
        
            Alamofire.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in
            
                switch response.result {
            
                case .success(let value):
                    self?.responseJSON(value: value)
                    completion()

                case .failure(let error):
                    print(error)
                }
            }

            self?.assignedCryptoNames.removeAll()
            self?.assignedCryptoSubNames.removeAll()
            self?.assignedCryptoRates.removeAll()
            self?.assignedCryptoPreviousRates.removeAll()
            self?.assignedCryptoIcon.removeAll()
        })
    }
    
    private func responseJSON(value: Any) {
        
        let jsonValue = JSON(value)
        var arrayCryptocurrenyNames: [String] = []
        var arrayCryptocurrencySubNames: [String] = []
        var arrayCryptocurrencyRates: [String] = []
        var arrayCryptocurrencyPreviousRates: [String] = []
        
        for names in self.chosenCryptocurrencyNames {
        
            let json = JSON(jsonValue)["items"][names]
            let cryptocurrency = Cryptocurrency(json: json)
            let removingUselessString = names.replacingOccurrences(of: "-PLN", with: "")
        
            arrayCryptocurrenyNames.append(self.settingTheMainNameOfCryptocurrency(getName: names))
            arrayCryptocurrencySubNames.append(removingUselessString)
            arrayCryptocurrencyRates.append(cryptocurrency.rate ?? "")
            arrayCryptocurrencyPreviousRates.append(self.calculatingThePercentageDifference(rate: cryptocurrency.rate ?? "", previousRate: cryptocurrency.previousRate ?? ""))
            self.assignedCryptoIcon = self.chosenCryptocurrencyImage
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
                self.assignedCryptoRates.append(arrayCryptocurrencyRates[i])
            
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
    
    func turnOffTheCounter() {
        
        timer?.invalidate()
    }
    
    func deleteCoreData(indexPath: IndexPath, completion: @escaping () -> Void) {
                 
        let context = persistence.context
        
        let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
        fetchRequest.predicate = NSPredicate(format: "title = %@", chosenCryptocurrencyNames[indexPath.row])
        fetchRequest.predicate = NSPredicate(format: "value = %@", chosenCryptocurrencyRates[indexPath.row])
        fetchRequest.predicate = NSPredicate(format: "previous = %@", chosenCryptocurrencyPreviousRates[indexPath.row])
        fetchRequest.predicate = NSPredicate(format: "image = %@", chosenCryptocurrencyImage[indexPath.row])

        do {
            if let result = try? context.fetch(fetchRequest) {
            
                for object in result {
                    context.delete(object)
                    chosenCryptocurrencyNames.remove(at: indexPath.row)
                    chosenCryptocurrencyRates.remove(at: indexPath.row)
                    chosenCryptocurrencyPreviousRates.remove(at: indexPath.row)
                    chosenCryptocurrencyImage.remove(at: indexPath.row)

                    completion()
                }
            }

            do {
                try context.save()
            } catch {
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
          
        if percentResult > 0.0 {
            percentColors.append(.green)
        } else {
            percentResult = percentResult * (-1)
            percentColors.append(.red)
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
            print("There is a problem with that cryptocurrency")
        }
        
        return nameReceived
    }
}
