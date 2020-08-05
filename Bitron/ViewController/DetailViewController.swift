//
//  DetailViewController.swift
//  Bitron
//
//  Created by user175293 on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
        
    let networking = Networking.shared
    var chosenCryptocurrency = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = chosenCryptocurrency
        view.backgroundColor = .white
    }
        
    func readData() {

        DispatchQueue.main.async {
            let urlPath = "https://api.bitbay.net/rest/trading/ticker"
            self.networking.request(urlPath) { [weak self] (result) in
        
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(Crypto.self, from: data)

                        /*self?.cryptoNames = [
                            response.items.btc.market.code,
                            response.items.eth.market.code,
                            response.items.ltc.market.code,
                            response.items.lsk.market.code,
                            response.items.alg.market.code,
                            response.items.trx.market.code,
                            response.items.amlt.market.code,
                            response.items.neu.market.code,
                            response.items.bob.market.code,
                            response.items.xrp.market.code
                        ]

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
                        ]*/
                               
                        DispatchQueue.main.async {
                            //self?.initObjects.cryptoTableView.reloadData()
                        }
                               
                    } catch let error {
                        print(error)
                    }
                           
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
        
    /* func deleteData(index: IndexPath) {
               
        let context = persistence.context
               
        let fetchRequest = NSFetchRequest<CryptoModel>(entityName: "CryptoModel")
               
        //fetchRequest.predicate = NSPredicate(format: "time = %@", chosenCryptoTime[index.row])
        fetchRequest.predicate = NSPredicate(format: "title = %@", chosenCryptoNames?[index.row] as! CVarArg)
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
