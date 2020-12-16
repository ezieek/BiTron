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
    private lazy var model: [DetailCryptocurrencyModel] = [DetailCryptocurrencyModel]()
    private lazy var high:   [String] = []
    private lazy var low:    [String] = []
    private lazy var volume: [String] = []
    private lazy var open:   [String] = []
    private lazy var close:  [String] = []
   
    // MARK: - internal
    func getJSONChartData(cryptocurrencyName: String, resolution: String, completion: @escaping ([DetailCryptocurrencyModel]) -> ()) {

        AF.request("https://api.bitbay.net/rest/trading/candle/history/\(cryptocurrencyName)/\(resolution)?from=1605614400000&to=\(1605787200)000").responseJSON { [self] (response) in
            
            switch response.result {
            
            case .success(let value):
                for i in 0...1 {
                    let json = JSON(value)["items"][i][1]
                    self.high.append(json["h"].stringValue)
                    self.low.append(json["l"].stringValue)
                    self.volume.append(json["v"].stringValue)
                    self.open.append(json["o"].stringValue)
                    self.close.append(json["c"].stringValue)
                    
                    self.model.append(DetailCryptocurrencyModel(high: high[i], low: low[i], volume: volume[i], open: open[i], close: close[i]))
                }
                
                completion(self.model)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
