//
//  DetailCryptocurrencyViewController.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import CoreData
import Charts

class DetailCryptocurrencyViewController: UIViewController {
    
    // MARK: - Properties
    weak var coordinatorDetail: DetailCryptocurrencyCoordinator?
    weak var coordinatorChosen: ChosenCryptocurrencyCoordinator?
    weak var coordinatorSelect: SelectCryptocurrencyCoordinator?
    private lazy var contentView = DetailCryptocurrencyView()
    private lazy var settingBackgroundColor = Colors()
    private lazy var detailViewModel = DetailCryptocurrencyViewModel()
    let networking = Networking.shared
    let persistence = Persistence.shared
    var pushedCryptocurrencyName: String = ""
    var pushedCryptocurrencySubName: String = ""
    var pushedCryptocurrencyRate: String = ""
    var pushedCryptocurrencyPreviousRate: String = ""
    var pushedCryptocurrencyImage: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        detailViewModel.detailCryptocurrencyShortName.append(pushedCryptocurrencySubName)
        setupView()
        contentViewActions()
        detailViewModel.getJSON {
            //print("HIGH: \(self.detailViewModel.detailCryptocurrencyHighValue), LOW: \(self.detailViewModel.detailCryptocurrencyLowValue) VOLUME: \(self.detailViewModel.detailCryptocurrencyVolumeValue)")
           // self.contentView.cryptocurrencyVolumeLabel.text = self.detailViewModel.detailCryptocurrencyVolumeValue
        }
        
        contentView.chartView.delegate = self
        
        setDataCount(Int(3), range: Int(10))
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        //add code here
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)

        //add code here
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
        
        let data = CandleChartData(dataSet: set1)
        contentView.chartView.data = data
    }
    // MARK: - private
    private func setupView() {
        navigationItem.title = "\(pushedCryptocurrencyName) (\(pushedCryptocurrencySubName))"
        view.layer.insertSublayer(settingBackgroundColor.gradientColor, at: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .done, target: self, action: #selector(backButtonPressed))
    }
    
    private func contentViewActions() {
        contentView.cryptocurrencyNameLabel.text = "\(pushedCryptocurrencySubName) / PLN"
        contentView.cryptocurrencyRateLabel.text = "\(pushedCryptocurrencyRate) PLN"
        contentView.cryptocurrencyPercentageRateLabel.text = "tak"
        contentView.cryptocurrencyVolumeLabel.text = "Volume 24h PLN"
        contentView.pushNotificationButton.addTarget(self, action: #selector(deleteDataButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - @objc selectors
    @objc private func backButtonPressed() {
        coordinatorChosen?.pushBackToChosenCryptocurrencyViewController()
        coordinatorSelect?.pushBackToSelectCryptocurrencyViewController()
    }
    
    @objc private func deleteDataButtonPressed() {
        persistence.deleteCoreData(name: pushedCryptocurrencyName, rate: pushedCryptocurrencyRate, previousRate: pushedCryptocurrencyPreviousRate, image: pushedCryptocurrencyImage)
        coordinatorChosen?.pushBackToChosenCryptocurrencyViewController()
    }
}

extension DetailCryptocurrencyViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Entry: \(entry)")
    }
}
