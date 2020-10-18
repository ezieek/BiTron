//
//  DetailView.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

//tutaj moze zrobic tak, ze on nie bedzie przesylac danych z FavoritesViewControllera tylko do razu bedzie pobierac z bitbay api aktualna wartosc
//tak jak ja to widze to z lewej ma byc aktualna wartosc danej kryptowaluty a po prawej jej Wolumin
//na srodku pod nimi moze byc procentowa zmiana aktualnej wartosci
//lekko nizej jakos wydobyc wartosci by zrobic z tego wykres
//na dole cos trzeba dodac

import UIKit

class DetailView: UIView {

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
    
    lazy var pushNotificationButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .red
        button.setTitle("Push Notifications Enabled", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        [cryptocurrencyNameLabel, cryptocurrencyRateLabel, cryptocurrencyPercentageRateLabel, cryptocurrencyVolumeLabel, pushNotificationButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            cryptocurrencyNameLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            cryptocurrencyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            cryptocurrencyRateLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: cryptocurrencyNameLabel.bottomAnchor, constant: 15),
            cryptocurrencyRateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            cryptocurrencyPercentageRateLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            cryptocurrencyPercentageRateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            cryptocurrencyVolumeLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            cryptocurrencyVolumeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            pushNotificationButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: screen.height * 0.8),
            pushNotificationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            pushNotificationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            pushNotificationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}
