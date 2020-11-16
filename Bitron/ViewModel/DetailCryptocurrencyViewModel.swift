//
//  DetailCryptocurrencyViewModel.swift
//  Bitron
//
//  Created by Maciej Wołejko 10/16/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class DetailCryptocurrencyViewModel {
    
    // MARK: - Properties
    lazy var detailCryptocurrencyShortName:   String = ""
    lazy var detailCryptocurrencyHighValue:   String = ""
    lazy var detailCryptocurrencyLowValue:    String = ""
    lazy var detailCryptocurrencyVolumeValue: String = ""
    
    // MARK: - internal
    //i teraz to wrzucic w timer, niech sie zmienia?
    //chociaz po co zmniejszac wydajnosc apki
    //badz po co dorzucac nowa funkcjonalnosc, niech on sprawdza ta wartosc wtedy kiedy tu wejdzie
    //przydaloby sie jeszcze dorzucic wartosci sprzed x czasu, ale to trzeba znalezc na bitbay api
    //w celu wygenerowania wykresu
    func getJSON(completion: @escaping () -> Void) {
        Alamofire.request("https://api.bitbay.net/rest/trading/stats").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonValue = JSON(value)
                self.detailCryptocurrencyShortName.append("-PLN")
                let json = JSON(jsonValue)["items"][self.detailCryptocurrencyShortName]
                let detailCryptocurrency = DetailCryptocurrency(json: json)
                
                self.detailCryptocurrencyHighValue = detailCryptocurrency.h ?? ""
                self.detailCryptocurrencyLowValue = detailCryptocurrency.l ?? ""
                self.detailCryptocurrencyVolumeValue = detailCryptocurrency.v ?? ""
                
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
