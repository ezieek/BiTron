//
//  Constants.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/18/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation

struct Constants {
    
    private init () {}
    static let shared = Constants()
    
    static let sqlBasePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    func settingMainNameOfCryptocurrency(getName: String) -> String {
        var nameReceived: String = ""
        switch getName {
        case "ZRX-PLN":  nameReceived = "1 0x"
        case "ALG-PLN":  nameReceived = "2 Algory"
        case "AMLT-PLN": nameReceived = "3 AMLT"
        case "REP-PLN":  nameReceived = "4 Augur"
        case "BAT-PLN":  nameReceived = "5 Basic Attention Token"
        case "BTC-PLN":  nameReceived = "6 Bitcoin"
        case "BCC-PLN":  nameReceived = "7 Bitcoin Cash"
        case "BTG-PLN":  nameReceived = "8 Bitcoin Gold"
        case "BSV-PLN":  nameReceived = "9 Bitcoin SV"
        case "BCP-PLN":  nameReceived = "10 Blockchain Poland"
        case "BOB-PLN":  nameReceived = "11 Bob's Repair"
        case "LINK-PLN": nameReceived = "12 Chainlink"
        case "DASH-PLN": nameReceived = "13 Dash"
        case "ETH-PLN":  nameReceived = "14 Ethereum"
        case "EXY-PLN":  nameReceived = "15 Experty"
        case "GAME-PLN": nameReceived = "16 Game Credits"
        case "GNT-PLN":  nameReceived = "17 Golem"
        case "XIN-PLN":  nameReceived = "18 Infinity Economics"
        case "LSK-PLN":  nameReceived = "19 Lisk"
        case "LML-PLN":  nameReceived = "20 Lisk Machine Learning"
        case "LTC-PLN":  nameReceived = "21 Litecoin"
        case "MKR-PLN":  nameReceived = "22 Maker"
        case "NEU-PLN":  nameReceived = "23 Neumark"
        case "OMG-PLN":  nameReceived = "24 OmniseGO"
        case "XRP-PLN":  nameReceived = "25 Ripple"
        case "XLM-PLN":  nameReceived = "26 Stellar"
        case "PAY-PLN":  nameReceived = "27 TenX"
        case "TRX-PLN":  nameReceived = "28 Tron"
        case "ZEC-PLN":  nameReceived = "29 Zcash"
        default:         nameReceived = "Error!"
        }
        return nameReceived
    }
}
