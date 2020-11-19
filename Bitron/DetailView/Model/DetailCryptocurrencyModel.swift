//
//  DetailCryptocurrencyModel.swift
//  Bitron
//
//  Created by Maciej Wołejko on 10/16/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DetailCryptocurrencyModel {
    
    var h: String? //the highest value
    var l: String? //the lowest value
    var v: String? //volume value
    var o: String? //open value
    var c: String? //close value
}

extension DetailCryptocurrencyModel {
    
    enum PropertyKey: String {
        case h, l, v, o, c
    }
    
    init(json: JSON) {
        h = json[PropertyKey.h.rawValue].stringValue
        l = json[PropertyKey.l.rawValue].stringValue
        v = json[PropertyKey.v.rawValue].stringValue
        o = json[PropertyKey.o.rawValue].stringValue
        c = json[PropertyKey.c.rawValue].stringValue
    }
}
