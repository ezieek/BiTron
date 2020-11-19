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
    
    
    var set1 = CandleChartDataSet()
    
    // MARK: - internal
    func getJSONChartData(cryptocurrencyName: String, resolution: String, actualTimestamp: String, completion: @escaping () -> Void) {
        Alamofire.request("https://api.bitbay.net/rest/trading/candle/history/\(cryptocurrencyName)/\(resolution)?from=1605614400000&to=\(1605787200)000").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                for i in 0...1 {
                
                    let json = JSON(value)["items"][i][1]
                    let model = DetailCryptocurrencyModel(json: json)

                completion()
                }
            case .failure(let error):
            print(error)
            }
        }
    }
    
    func setDataCount(_ count: Int, range: Int) {
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
            let high = [36155.44, 35448.5, 34400.0]
            let low = [33650.0, 33400.0, 32431.67]
            let open = [36104.08, 34217.79, 34358.5]
            let close = [34161.41, 34275.86, 34275.86]
            
            return CandleChartDataEntry(x: Double(i), shadowH: high[i], shadowL: low[i], open: open[i], close: close[i])
        }
        
        
        let set1 = CandleChartDataSet(entries: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .green
        set1.valueTextColor = .white
        
       // let data = CandleChartData(dataSet: set1)
       // contentView.chartView.data = data
    }
}
