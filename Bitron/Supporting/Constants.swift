//
//  Constants.swift
//  Bitron
//
//  Created by Maciej Wołejko on 9/18/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation

struct Constants {
    
    static let sqlBasePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    static func settingMainNameOfCryptocurrency(getName: String) -> String {
        var nameReceived: String = ""
        
        switch(getName) {
        case "XLM-PLN":  nameReceived = "Stellar"
        case "BTC-PLN":  nameReceived = "Bitcoin"
        case "BCC-PLN":  nameReceived = "Bitcoin Cash"
        case "NEU-PLN":  nameReceived = "Neumark"
        case "BCP-PLN":  nameReceived = "Blockchain Poland"
        case "EXY-PLN":  nameReceived = "Experty"
        case "LML-PLN":  nameReceived = "Lisk Machine Learning"
        case "BOB-PLN":  nameReceived = "Bob's Repair"
        case "XIN-PLN":  nameReceived = "Infinity Economics"
        case "BTG-PLN":  nameReceived = "Bitcoin Gold"
        case "AMLT-PLN": nameReceived = "AMLT"
        case "MKR-PLN":  nameReceived = "Maker"
        case "XRP-PLN":  nameReceived = "Ripple"
        case "ZRX-PLN":  nameReceived = "0x"
        case "GNT-PLN":  nameReceived = "Golem"
        case "LINK-PLN": nameReceived = "Chainlink"
        case "LSK-PLN":  nameReceived = "Lisk"
        case "GAME-PLN": nameReceived = "Game Credits"
        case "LTC-PLN":  nameReceived = "Litecoin"
        case "BAT-PLN":  nameReceived = "Basic Attention Token"
        case "TRX-PLN":  nameReceived = "Tron"
        case "PAY-PLN":  nameReceived = "TenX"
        case "ZEC-PLN":  nameReceived = "Zcash"
        case "DASH-PLN": nameReceived = "Dash"
        case "OMG-PLN":  nameReceived = "OmniseGO"
        case "ETH-PLN":  nameReceived = "Ethereum"
        case "ALG-PLN":  nameReceived = "Algory"
        case "BSV-PLN":  nameReceived = "Bitcoin SV"
        case "REP-PLN":  nameReceived = "Augur"
        default:         nameReceived = "Error!"
        }
        
        return nameReceived
    }
}
