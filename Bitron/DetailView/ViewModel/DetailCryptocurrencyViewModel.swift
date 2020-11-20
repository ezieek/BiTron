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
import Charts

class DetailCryptocurrencyViewModel {
    
    // MARK: - Properties
    lazy var detailCryptocurrencyShortName:   String = ""
    lazy var detailCryptocurrencyHighValue:   [String] = []
    lazy var detailCryptocurrencyLowValue:    [String] = []
    lazy var detailCryptocurrencyVolumeValue: [String] = []
    lazy var detailCryptocurrencyOpenValue:   [String] = []
    lazy var detailCryptocurrencyCloseValue:  [String] = []
    
    // MARK: - internal
    func getJSONChartData(cryptocurrencyName: String, resolution: String, completion: @escaping () -> Void) {
        AF.request("https://api.bitbay.net/rest/trading/candle/history/\(cryptocurrencyName)/\(resolution)?from=1605614400000&to=\(1605787200)000").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                for i in 0...1 {
                    let json = JSON(value)["items"][i][1]
                    let model = DetailCryptocurrencyModel(json: json)
                    self.detailCryptocurrencyHighValue.append(model.h!)
                    self.detailCryptocurrencyLowValue.append(model.l!)
                    self.detailCryptocurrencyOpenValue.append(model.o!)
                    self.detailCryptocurrencyCloseValue.append(model.c!)
                    completion()
                }
            case .failure(let error):
            print(error)
            }
        }
    }
}
