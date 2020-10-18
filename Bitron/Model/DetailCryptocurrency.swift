//
//  DetailCryptocurrency.swift
//  Bitron
//
//  Created by Maciej Wołejko on 10/16/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import UIKit
import SwiftyJSON

struct DetailCryptocurrency {
    
    var h: String? //the highest value from 24h
    var l: String? //the lowest value from 24h
    var v: String? //volume from 24h
}

extension DetailCryptocurrency {
    
    enum PropertyKey: String {
        case h, l, v
    }
    
    init(json: JSON) {
        h = json[PropertyKey.h.rawValue].stringValue
        l = json[PropertyKey.l.rawValue].stringValue
        v = json[PropertyKey.v.rawValue].stringValue
    }
}
