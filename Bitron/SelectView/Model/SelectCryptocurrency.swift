//
//  SelectCryptocurrency.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SelectCryptocurrency {
    
    var name: String?
    var time: String?
    var rate: String?
    var lowestAsk: String?
    var highestBid: String?
    var previousRate: String?
}

extension SelectCryptocurrency {
    
    enum PropertyKey: String {
        case name, time, rate, lowestAsk, highestBid, previousRate
    }
        
    init(json: JSON) {
        name = json[PropertyKey.name.rawValue].stringValue
        time = json[PropertyKey.time.rawValue].stringValue
        rate = json[PropertyKey.rate.rawValue].stringValue
        lowestAsk = json[PropertyKey.lowestAsk.rawValue].stringValue
        highestBid = json[PropertyKey.highestBid.rawValue].stringValue
        previousRate = json[PropertyKey.previousRate.rawValue].stringValue
    }
}
