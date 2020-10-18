//
//  DetailCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData

class DetailCryptocurrencyViewController: UIViewController {

    weak var coordinator: ApplicationCoordinator?
    let initObjects = DetailView()
    let colors = Colors()
    let networking = Networking.shared
    let persistence = Persistence.shared
    
    var pushedCryptocurrencyName: String = ""
    var pushedCryptocurrencySubName: String = ""
    var pushedCryptocurrencyRate: String = ""
    var pushedCryptocurrencyPreviousRate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
       // retriveCoreData()
       // parseJSONData()
    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
    }
    
    private func setupView() {
        
        navigationItem.title = "\(pushedCryptocurrencyName) (\(pushedCryptocurrencySubName))"
        initObjects.cryptocurrencyNameLabel.text = "\(pushedCryptocurrencySubName) / PLN"
        initObjects.cryptocurrencyRateLabel.text = "\(pushedCryptocurrencyRate) PLN"
        initObjects.cryptocurrencyPercentageRateLabel.text = "tak"
        initObjects.cryptocurrencyVolumeLabel.text = "Volume 24h PLN"
        view.layer.insertSublayer(colors.gradientColor, at: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .done, target: self, action: #selector(backButtonPressed))
        initObjects.pushNotificationButton.addTarget(self, action: #selector(deleteDataButtonPressed), for: .touchUpInside)
    }
    
    @objc private func deleteDataButtonPressed() {
        print(1)
        
           // deleteData()
    }
    
    @objc private func backButtonPressed() {
        
        coordinator?.mainView()
    }
    
    
    /*  func deleteData(index: IndexPath) {
                 
          let context = persistence.context
                 
          let fetchRequest = NSFetchRequest<CryptocurrencyModel>(entityName: "CryptocurrencyModel")
                 
          fetchRequest.predicate = NSPredicate(format: "title = %@", chosenCryptoNames[index.row])
          fetchRequest.predicate = NSPredicate(format: "value = %@", chosenCryptoRates[index.row])
          fetchRequest.predicate = NSPredicate(format: "previous = %@", chosenCryptoPreviousRates[index.row])

          do {
              
              if let result = try? context.fetch(fetchRequest) {
                  for object in result {
                      context.delete(object)
                      chosenCryptoNames.remove(at: index.row)
                      chosenCryptoRates.remove(at: index.row)
                      chosenCryptoPreviousRates.remove(at: index.row)
                      initObjects.mainTableView.deleteRows(at: [index], with: .middle)
                      initObjects.mainTableView.reloadData()
                  }
              }

              do {
                  try context.save()
              } catch {
                  print(error)
              }
          }
      }*/
    
}
