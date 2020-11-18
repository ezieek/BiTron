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
    func getJSON(completion: @escaping () -> Void) {
        Alamofire.request("https://api.bitbay.net/rest/trading/stats").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonValue = JSON(value)
                self.detailCryptocurrencyShortName.append("-PLN")
                let json = JSON(jsonValue)["items"][self.detailCryptocurrencyShortName]
                let detailCryptocurrency = DetailCryptocurrencyModel(json: json)
                
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
