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
import Charts

class DetailCryptocurrencyViewModel {
    
    // MARK: - Properties
    weak var timer:          Timer?
    private lazy var model:  [DetailCryptocurrencyModel] = [DetailCryptocurrencyModel]()
    private lazy var high:   [String] = []
    private lazy var low:    [String] = []
    private lazy var volume: [String] = []
    private lazy var open:   [String] = []
    private lazy var close:  [String] = []
    lazy var rate:           [String] = []
    lazy var lowestRate:     [String] = []
    
    // MARK: - internal
    func getCurrentValue(name: String, completion: @escaping([DetailCryptocurrencyModel]) -> ()) {
        let timeInterval = 1.0
      
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            AF.request("https://api.bitbay.net/rest/trading/ticker").responseJSON { [weak self] (response) in

                switch response.result {
                
                case .success(let value):
                    let jsonValue = JSON(value)
                    let json = JSON(jsonValue)["items"][name]
                    self?.rate.append(json["rate"].stringValue)
                    
                    self?.model.append(DetailCryptocurrencyModel(
                        high: "",
                        low: "",
                        volume: "",
                        open: "",
                        close: "",
                        rate: self?.rate[0] ?? "",
                        lowestRate: ""))
                    
                    completion(self?.model ?? [])
                    
                case .failure(let error):
                    print(error)
                }
                
                self?.model.removeAll()
                self?.rate.removeAll()
            }
        })
    }
    
    func getJSONChartData(cryptocurrencyName: String, resolution: String, completion: @escaping ([DetailCryptocurrencyModel]) -> ()) {
        let currentTimestamp = Int(NSDate().timeIntervalSince1970)
        let fromTimestamp = startingTime(currentTimestamp: currentTimestamp, resolution: Int(resolution) ?? 0)
        
        AF.request("https://api.bitbay.net/rest/trading/candle/history/\(cryptocurrencyName)/\(resolution)?from=\(fromTimestamp)000&to=\(currentTimestamp)000").responseJSON { [weak self] (response) in

            switch response.result {
            
            case .success(let value):
                for i in 0..<50 {
                    let json = JSON(value)["items"][i][1]
                    if json.exists() {
                        self?.high.append(json["h"].stringValue)
                        self?.low.append(json["l"].stringValue)
                        self?.volume.append(json["v"].stringValue)
                        self?.open.append(json["o"].stringValue)
                        self?.close.append(json["c"].stringValue)
                        self?.lowestRate.append(self?.low.min() ?? "")

                        self?.model.append(DetailCryptocurrencyModel(
                            high: self?.high[i] ?? "",
                            low: self?.low[i] ?? "",
                            volume: self?.volume[i] ?? "",
                            open: self?.open[i] ?? "",
                            close: self?.close[i] ?? "",
                            rate: "",
                            lowestRate: self?.lowestRate[i] ?? ""))
                    }
                }

                completion(self?.model ?? [])
                
            case .failure(let error):
                print(error)
            }
            
            self?.cleanDetailCryptocurrencyData()
        }
    }
    
    func setDataCount(count: Int) -> ChartData {
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
            let dataModel = model[i]
            
            return CandleChartDataEntry(x: Double(i), shadowH: Double(dataModel.high) ?? 0.0, shadowL: Double(dataModel.low) ?? 0.0, open: Double(dataModel.open) ?? 0.0, close: Double(dataModel.close) ?? 0.0)
        }
        
        let dataSet = CandleChartDataSet(entries: yVals1, label: "Data Set")
        dataSet.axisDependency = .left
        dataSet.setColor(UIColor(white: 80/255, alpha: 1))
        dataSet.drawIconsEnabled = false
        dataSet.shadowColorSameAsCandle = true
        dataSet.shadowWidth = 0.7
        dataSet.decreasingColor = .red
        dataSet.decreasingFilled = true
        dataSet.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        dataSet.increasingFilled = false
        dataSet.neutralColor = .green
        dataSet.valueTextColor = .clear
        
        let data = CandleChartData(dataSet: dataSet)
        return data
    }
    
    // MARK: - private
    private func startingTime(currentTimestamp: Int, resolution: Int) -> String {
        let numberOfSticks = 50
        let timeRange = numberOfSticks * resolution
        let startingTime = currentTimestamp - timeRange
        return String(startingTime)
    }
    
    private func cleanDetailCryptocurrencyData() {
        self.model.removeAll()
        self.high.removeAll()
        self.low.removeAll()
        self.open.removeAll()
        self.close.removeAll()
    }
}
