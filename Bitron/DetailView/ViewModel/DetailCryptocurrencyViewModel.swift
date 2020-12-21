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

        AF.request("https://api.bitbay.net/rest/trading/candle/history/\(cryptocurrencyName)/\(resolution)?from=\(fromTimestamp)000&to=\(currentTimestamp)000").responseJSON { [weak self] (response) in

            switch response.result {
            
            case .success(let value):
                for i in 0...49 {
                    let json = JSON(value)["items"][i][1]
                    self?.high.append(json["h"].stringValue)
                    self?.low.append(json["l"].stringValue)
                    self?.volume.append(json["v"].stringValue)
                    self?.open.append(json["o"].stringValue)
                    self?.close.append(json["c"].stringValue)

                    self?.model.append(DetailCryptocurrencyModel(
                        high: self?.high[i] ?? "",
                        low: self?.low[i] ?? "",
                        volume: self?.volume[i] ?? "",
                        open: self?.open[i] ?? "",
                        close: self?.close[i] ?? ""))
                }

                completion(self?.model ?? [])
                
            case .failure(let error):
                print(error)
            }
            self?.cleanDetailCryptocurrencyData()
        }
    }
    
    // MARK: - private
    private func cleanDetailCryptocurrencyData() {
        self.model.removeAll()
        self.high.removeAll()
        self.low.removeAll()
        self.open.removeAll()
        self.close.removeAll()
    }
}
