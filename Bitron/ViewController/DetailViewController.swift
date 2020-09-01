//
//  DetailViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    let initObjects = DetailView()
    let colors = Colors()
    let networking = Networking.shared
    let persistence = Persistence.shared
    var savedCryptoNames: [String] = []
    var chosenCryptocurrencyName = [""]
    var chosenCryptocurrencyRate: [String] = []
    var cryptoRates = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = chosenCryptocurrencyName[0]
       // initObjects.rateLabel.text = chosenCryptocurrencyRate
        view.layer.insertSublayer(colors.gradientColor, at: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: .done, target: self, action: #selector(backButtonPressed))
        parseJSONData()
        
    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
    }
    
    @objc func backButtonPressed() {
        
        coordinator?.mainView()
    }
        
    //chodzi o to, zeby parsowac tutaj rate danej krypto, teraz slabo to dziala
    func parseJSONData() {

    //DispatchQueue.main.async {
            
        let urlPath = "https://api.bitbay.net/rest/trading/ticker"
        self.networking.request(urlPath) { [weak self] (result) in
                
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Crypto.self, from: data)
                       
                    self?.cryptoRates = [
                        response.items.btc.rate,
                        response.items.eth.rate,
                        response.items.ltc.rate,
                        response.items.lsk.rate,
                        response.items.alg.rate,
                        response.items.trx.rate,
                        response.items.amlt.rate,
                        response.items.neu.rate,
                        response.items.bob.rate,
                        response.items.xrp.rate
                    ]
                    
                   // var currentIndex = 0
                        
                    for name in self?.chosenCryptocurrencyName ?? [] {
                        
                    switch(name) {
                        case "BTC-PLN":
                            print(response.items.btc
                                .rate)
                            //self?.initObjects.rateLabel.text = response.items.btc.rate
                            //self?.chosenCryptocurrencyRate[0] = response.items.btc.rate
                        
                            //self?.chosenCryptocurrencyRate[currentIndex] = response.items.btc.rate
                       // print("weszlo tu")
                      /*  case "ETH-PLN":
                            self?.chosenCryptocurrencyRate[currentIndex] = response.items.eth.rate
                        case "LTC-PLN":
                            self?.chosenCryptocurrencyRate[currentIndex] = response.items.ltc.rate
                        case "LSK-PLN":
                            self?.chosenCryptocurrencyRate[currentIndex] = response.items.lsk.rate
                        case "ALG-PLN":
                            self?.chosenCryptocurrencyRate[currentIndex] = response.items.alg.rate
                        case "TRX-PLN":
                            self?.chosenCryptocurrencyRate[currentIndex] = response.items.trx.rate
                        case "AMLT-PLN":
                            self?.chosenCryptocurrencyRate[currentIndex] = response.items.amlt.rate
                        case "NEU-PLN":
                            self?.chosenCryptocurrencyRate[currentIndex] = response.items.neu.rate
                        case "BOB-PLN":
                            self?.chosenCryptocurrencyRate[currentIndex] = response.items.bob.rate*/
                        default:
                            //self?.chosenCryptocurrencyRate[currentIndex] = response.items.xrp.rate
                        print("asdasd")
                        }
                        //currentIndex += 1
                    }

                    /*DispatchQueue.main.async {
                        self?.initObjects.rateLabel.text = self?.chosenCryptocurrencyRate[currentIndex]
                        
                    }*/
                    
                } catch let error {
                    print(error)
                }
                    
            case .failure(let error):
                print(error)
            }
        }
    }
    //}
    /* func deleteData(index: IndexPath) {
               
        let context = persistence.context
               
        let fetchRequest = NSFetchRequest<CryptoModel>(entityName: "CryptoModel")
               
        //fetchRequest.predicate = NSPredicate(format: "time = %@", chosenCryptoTime[index.row])
        fetchRequest.predicate = NSPredicate(format: "title = %@", savedCryptoNames[index.row] as CVarArg)
        fetchRequest.predicate = NSPredicate(format: "value = %@", chosenCryptoRates[index.row])

        do {
            let test = try context.fetch(fetchRequest)
            let objectToDelete = test[0] as NSManagedObject
            context.delete(objectToDelete)
            chosenCryptoTime.remove(at: index.row)
            chosenCryptoNames?.remove(at: index.row)
            chosenCryptoRates.remove(at: index.row)
            initObjects.mainTableView.deleteRows(at: [index], with: .fade)

            do {
                try context.save()
            } catch {
                print(error)
            }
                   
        } catch {
            print("There is an error deleting data")
        }
    }*/
}
