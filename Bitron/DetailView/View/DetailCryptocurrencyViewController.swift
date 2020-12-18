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
        detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "3600", fromTimestamp: fromTimestamp()) { (model) in
            let modelCount = model[0]
            self.model = model
            self.setDataCount(count: modelCount.count)
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
    private func fromTimestamp() -> String {
        let currentTimeStamp = Int(NSDate().timeIntervalSince1970)
        let numberOfSticks = 50
        let diffrenceNumber = numberOfSticks * 3600
        let value = currentTimeStamp - diffrenceNumber
        return String(value)
    }

    private func buttonPanelSettings() {
        [buttonPanelView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            buttonPanelView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150),
            buttonPanelView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -220)
        ])
        
        buttonPanelView.selectedTimeButton.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)
        buttonPanelView.oneYearButton.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
        buttonPanelView.oneMonthButton.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
        buttonPanelView.oneWeekButton.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
        buttonPanelView.oneDayButton.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
        buttonPanelView.oneHourButton.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
        buttonPanelView.thirtyMinutesButton.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
        buttonPanelView.fifteenMinutesButton.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
        buttonPanelView.oneMinuteButton.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
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
    @objc func expandButtonPressed() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.buttonPanelView.expandedStackView.subviews.forEach { $0.isHidden = !$0.isHidden }
            self.buttonPanelView.expandedStackView.isHidden = !self.buttonPanelView.expandedStackView.isHidden
        }, completion: nil)
    }
    
    @objc func panelButtonPressed() {
        
      /*  if buttonPanelView.oneYearButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("Y", for: .normal)   //29030400
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "29030400", fromTimestamp: <#String#>) { (model) in
                let modelCount = model[0]
                self.model = model
                self.setDataCount(count: modelCount.count)
            }
        } else if buttonPanelView.oneMonthButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("M", for: .normal)   //2419200
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "2419200", fromTimestamp: <#String#>) { (model) in
                let modelCount = model[0]
                self.model = model
                self.setDataCount(count: modelCount.count)
            }
        } else if buttonPanelView.oneWeekButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("W", for: .normal)   //604800
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "604800", fromTimestamp: <#String#>) { (model) in
                let modelCount = model[0]
                self.model = model
                self.setDataCount(count: modelCount.count)
            }
        } else if buttonPanelView.oneDayButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("D", for: .normal)   //86400
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "86400", fromTimestamp: <#String#>) { (model) in
                let modelCount = model[0]
                self.model = model
                self.setDataCount(count: modelCount.count)
            }
        } else if buttonPanelView.oneHourButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("1h", for: .normal)  //3600
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "3600", fromTimestamp: <#String#>) { (model) in
                let modelCount = model[1]
                print("Wartosc: \(modelCount.count)")
                self.model = model
                self.setDataCount(count: modelCount.count)
            }
        } else if buttonPanelView.thirtyMinutesButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("30m", for: .normal) //1800
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "1800", fromTimestamp: <#String#>) { (model) in
                let modelCount = model[0]
                self.model = model
                self.setDataCount(count: modelCount.count)
            }
        } else if buttonPanelView.fifteenMinutesButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("15m", for: .normal) //900
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "900", fromTimestamp: <#String#>) { (model) in
                let modelCount = model[0]
                self.model = model
                self.setDataCount(count: modelCount.count)
            }
        } else {
            buttonPanelView.selectedTimeButton.setTitle("1m", for: .normal)  //60
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "60", fromTimestamp: <#String#>) { (model) in
                let modelCount = model[0]
                self.model = model
                self.setDataCount(count: modelCount.count)
            }
        }
    
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.buttonPanelView.expandedStackView.subviews.forEach { $0.isHidden = !$0.isHidden }
            self.buttonPanelView.expandedStackView.isHidden = !self.buttonPanelView.expandedStackView.isHidden
        }, completion: nil)*/
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
