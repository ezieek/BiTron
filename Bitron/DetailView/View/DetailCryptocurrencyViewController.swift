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
    private lazy var buttonPanelView = ButtonPanelView()
    private lazy var settingBackgroundColor = Colors()
    private lazy var detailViewModel = DetailCryptocurrencyViewModel()
    private lazy var model: [DetailCryptocurrencyModel] = []
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

        setupView()
        contentViewActions()
        buttonPanelSettings()
        contentView.chartView.delegate = self
        detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "86400") { (model) in
            self.model = model
            self.setDataCount(count: 2)
        }
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
    
    // MARK: - private
    private func buttonPanelSettings() {
        [buttonPanelView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            buttonPanelView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150),
            buttonPanelView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -220)
        ])
    }
    
    private func setDataCount(count: Int) {
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
            let dataModel = model[i]
            
            return CandleChartDataEntry(x: Double(i), shadowH: Double(dataModel.high) ?? 0.0, shadowL: Double(dataModel.low) ?? 0.0, open: Double(dataModel.open) ?? 0.0, close: Double(dataModel.close) ?? 0.0)
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
    
    private func setupView() {
        navigationItem.title = "\(pushedCryptocurrencyName) (\(pushedCryptocurrencySubName))"
        view.layer.insertSublayer(settingBackgroundColor.gradientColor, at: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow-left"), style: .done, target: self, action: #selector(backButtonPressed))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "rightNavBarButton"
        navigationItem.rightBarButtonItem?.isAccessibilityElement = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteDataButtonPressed))
    }
    
    private func contentViewActions() {
        contentView.cryptocurrencyNameLabel.text = "\(pushedCryptocurrencySubName) / PLN"
        contentView.cryptocurrencyRateLabel.text = "\(pushedCryptocurrencyRate) PLN"
        contentView.cryptocurrencyPercentageRateLabel.text = "Percentage Rate"
        contentView.cryptocurrencyVolumeLabel.text = "Volume 24h PLN"
        contentView.chartViewButtonPlus.addTarget(self, action: #selector(chartViewPlusButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - @objc selectors
    @objc private func expandButtons() {
        print(1)
    }
    
    @objc private func chartViewPlusButtonPressed() {
        print(1)
    }

    @objc private func backButtonPressed() {
        coordinatorChosen?.pushBackToChosenCryptocurrencyViewController()
        coordinatorSelect?.pushBackToSelectCryptocurrencyViewController()
    }
    
    @objc private func deleteDataButtonPressed() {
        persistence.deleteCoreData(name: pushedCryptocurrencyName, rate: pushedCryptocurrencyRate, previousRate: pushedCryptocurrencyPreviousRate, image: pushedCryptocurrencyImage)
        coordinatorChosen?.pushBackToChosenCryptocurrencyViewController()
    }
}
    
    // MARK: - Delegate
extension DetailCryptocurrencyViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Entry: \(entry)")
    }
}
