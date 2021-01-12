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
    weak var timer: Timer?
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
    var resolutionToSet: String = "3600"
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
        
        detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: "3600") { (model) in
            self.model = model
            self.contentView.chartView.data = self.detailViewModel.setDataCount(count: model.endIndex - 1)
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
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (_) in
            self.detailViewModel.getJSONChartData(cryptocurrencyName: "\(self.pushedCryptocurrencySubName)-PLN", resolution: self.resolutionToSet) { (model) in
                self.model = model
                self.contentView.chartView.data = self.detailViewModel.setDataCount(count: model.endIndex - 1)
            }
        })
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
        contentView.chartView.delegate = self
        contentView.chartViewButtonPlus.addTarget(self, action: #selector(chartViewPlusButtonPressed), for: .touchUpInside)
    }
    
    private func buttonPanelSettings() {
        [buttonPanelView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            buttonPanelView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150),
            buttonPanelView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -220)
        ])
        
        buttonPanelView.selectedTimeButton.addTarget(self, action: #selector(expandButtonPressed), for: .touchUpInside)

        let buttonNames = [buttonPanelView.oneWeekButton, buttonPanelView.oneDayButton, buttonPanelView.oneHourButton, buttonPanelView.thirtyMinutesButton, buttonPanelView.fifteenMinutesButton, buttonPanelView.oneMinuteButton]
        
        for buttonName in buttonNames {
            buttonName.addTarget(self, action: #selector(panelButtonPressed), for: .touchUpInside)
        }
    }
    
    private func setSelectedTimeButtonTitle(resolution: String) {
        switch resolution {
        case "604800":
            self.buttonPanelView.selectedTimeButton.setTitle("W", for: .normal)
        case "86400":
            self.buttonPanelView.selectedTimeButton.setTitle("D", for: .normal)
        case "3600":
            self.buttonPanelView.selectedTimeButton.setTitle("1h", for: .normal)
        case "1800":
            self.buttonPanelView.selectedTimeButton.setTitle("30m", for: .normal)
        case "900":
            self.buttonPanelView.selectedTimeButton.setTitle("15m", for: .normal)
        default:
            self.buttonPanelView.selectedTimeButton.setTitle("1m", for: .normal)
        }
    }
    
    // MARK: - @objc selectors
    @objc func panelButtonPressed() {
        let buttons = [
            buttonPanelView.oneWeekButton: "604800",
            buttonPanelView.oneDayButton: "86400",
            buttonPanelView.oneHourButton: "3600",
            buttonPanelView.thirtyMinutesButton: "1800",
            buttonPanelView.fifteenMinutesButton: "900",
            buttonPanelView.oneMinuteButton: "60"
        ]
        
        for (key, value) in buttons where key.isTouchInside {
            detailViewModel.getJSONChartData(cryptocurrencyName: "\(pushedCryptocurrencySubName)-PLN", resolution: value) { (model) in
                self.model = model
                self.resolutionToSet = value
                self.setSelectedTimeButtonTitle(resolution: value)
                self.contentView.chartView.data = self.detailViewModel.setDataCount(count: model.endIndex - 1)
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
