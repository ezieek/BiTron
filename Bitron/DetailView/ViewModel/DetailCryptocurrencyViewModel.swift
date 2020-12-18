//
//  DetailCryptocurrencyViewModel.swift
//  Bitron
//
//  Created by Maciej Wołejko 10/16/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DetailCryptocurrencyViewModel {
    
    // MARK: - Properties
    private lazy var model: [DetailCryptocurrencyModel] = [DetailCryptocurrencyModel]()
    private lazy var high:   [String] = []
    private lazy var low:    [String] = []
    private lazy var volume: [String] = []
    private lazy var open:   [String] = []
    private lazy var close:  [String] = []
   
    // MARK: - internal
    func getJSONChartData(cryptocurrencyName: String, resolution: String, fromTimestamp: String, completion: @escaping ([DetailCryptocurrencyModel]) -> ()) {
        let currentTimestamp = Int(NSDate().timeIntervalSince1970)

        AF.request("https://api.bitbay.net/rest/trading/candle/history/\(cryptocurrencyName)/\(resolution)?from=\(fromTimestamp)000&to=\(currentTimestamp)000").responseJSON { [self] (response) in
           // let time = currentTimestamp - Int(fromTimestamp)! / 1000
           // let numberOfSticks = time / Int(resolution)!

            switch response.result {
            
            case .success(let value):
                for i in 0...50 {//numberOfSticks {
                    let json = JSON(value)["items"][i][1]
                    self.high.append(json["h"].stringValue)
                    self.low.append(json["l"].stringValue)
                    self.volume.append(json["v"].stringValue)
                    self.open.append(json["o"].stringValue)
                    self.close.append(json["c"].stringValue)

                    self.model.append(DetailCryptocurrencyModel(high: high[i], low: low[i], volume: volume[i], open: open[i], close: close[i], count: 50))
                }
                
                completion(self.model)
                self.model.removeAll()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
