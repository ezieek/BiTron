//
//  DetailCryptocurrencyView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import Charts

class DetailCryptocurrencyView: UIView {

    // MARK: - Properties
    let screen = UIScreen.main.bounds
    
    lazy var cryptocurrencyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cryptocurrencyRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cryptocurrencyPercentageRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cryptocurrencyVolumeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cryptocurrencyVolumeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var chartView: CandleStickChartView = {
        let chartView = CandleStickChartView()
       /*chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 200
        chartView.pinchZoomEnabled = true
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .vertical
        chartView.legend.drawInside = false
        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!*/
        chartView.backgroundColor = .yellow
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    lazy var pushNotificationButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.setTitle("Push Notifications Enabled", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - init - deinit
    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private
    private func createSubViews() {
        [cryptocurrencyNameLabel, cryptocurrencyRateLabel, cryptocurrencyPercentageRateLabel, cryptocurrencyVolumeLabel, chartView, pushNotificationButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            cryptocurrencyNameLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            cryptocurrencyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            cryptocurrencyRateLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: cryptocurrencyNameLabel.bottomAnchor, constant: 15),
            cryptocurrencyRateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            cryptocurrencyPercentageRateLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            cryptocurrencyPercentageRateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            cryptocurrencyVolumeLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            cryptocurrencyVolumeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            pushNotificationButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: screen.height * 0.7),
            pushNotificationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            pushNotificationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            pushNotificationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80)
        ])
    }
}
