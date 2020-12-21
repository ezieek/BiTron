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
    private lazy var model: [DetailCryptocurrencyModel] = [DetailCryptocurrencyModel]()
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
        detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "86400", fromTimestamp: fromTimestamp(resolution: 86400)) { (model) in
            self.model = model
            self.setDataCount(count: 50)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        detailViewModel.getCurrentValue(name: "\(pushedCryptocurrencySubName)-PLN") { (model) in
            self.model = model
            self.contentView.cryptocurrencyRateLabel.text = "\(String(describing: model[0].rate)) PLN"
        }
    }
    
    // MARK: - private
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
    
    private func fromTimestamp(resolution: Int) -> String {
        let currentTimeStamp = Int(NSDate().timeIntervalSince1970)
        let numberOfSticks = 50
        let diffrenceNumber = numberOfSticks * resolution
        let value = currentTimeStamp - diffrenceNumber
        return String(value)
    }
    
    // MARK: - @objc selectors
    @objc func panelButtonPressed() {
        if buttonPanelView.oneYearButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("Y", for: .normal)
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "29030400", fromTimestamp: fromTimestamp(resolution: 29030400)) { (model) in
                self.model = model
                self.setDataCount(count: 50)
            }
        } else if buttonPanelView.oneMonthButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("M", for: .normal)
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "2419200", fromTimestamp: fromTimestamp(resolution: 2419200)) { (model) in
                self.model = model
                self.setDataCount(count: 50)
            }
        } else if buttonPanelView.oneWeekButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("W", for: .normal)
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "604800", fromTimestamp: fromTimestamp(resolution: 604800)) { (model) in
                self.model = model
                self.setDataCount(count: 50)
            }
        } else if buttonPanelView.oneDayButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("D", for: .normal)
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "86400", fromTimestamp: fromTimestamp(resolution: 86400)) { (model) in
                self.model = model
                self.setDataCount(count: 50)
            }
        } else if buttonPanelView.oneHourButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("1h", for: .normal)
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "3600", fromTimestamp: fromTimestamp(resolution: 3600)) { (model) in
                self.model = model
                self.setDataCount(count: 50)
            }
        } else if buttonPanelView.thirtyMinutesButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("30m", for: .normal)
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "1800", fromTimestamp: fromTimestamp(resolution: 1800)) { (model) in
                self.model = model
                self.setDataCount(count: 50)
            }
        } else if buttonPanelView.fifteenMinutesButton.isTouchInside {
            buttonPanelView.selectedTimeButton.setTitle("15m", for: .normal)
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "900", fromTimestamp: fromTimestamp(resolution: 900)) { (model) in
                self.model = model
                self.setDataCount(count: 50)
            }
        } else {
            buttonPanelView.selectedTimeButton.setTitle("1m", for: .normal)
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "60", fromTimestamp: fromTimestamp(resolution: 60)) { (model) in
                self.model = model
                self.setDataCount(count: 50)
            }
        }
    
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.buttonPanelView.expandedStackView.subviews.forEach { $0.isHidden = !$0.isHidden }
            self.buttonPanelView.expandedStackView.isHidden = !self.buttonPanelView.expandedStackView.isHidden
        }, completion: nil)
    }
    
    @objc func expandButtonPressed() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.buttonPanelView.expandedStackView.subviews.forEach { $0.isHidden = !$0.isHidden }
            self.buttonPanelView.expandedStackView.isHidden = !self.buttonPanelView.expandedStackView.isHidden
        }, completion: nil)
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
