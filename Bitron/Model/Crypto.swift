//
//  Crypto.swift
//  Bitron
//
//  Created by Maciej Wołejko on 8/5/20.
//  Copyright © 2020 Maciej Wołejko. All rights reserved.
//

import Foundation

struct Crypto: Codable {
    let status: String
    var items: Items
}

struct Items: Codable {
    enum CodingKeys: String, CodingKey {
        case btc = "BTC-PLN"
        case lml = "LML-PLN"
        case trx = "TRX-PLN"
        case lsk = "LSK-PLN"
        case eth = "ETH-PLN"
        case ltc = "LTC-PLN"
        case zrx = "ZRX-PLN"
        case bsv = "BSV-PLN"
        case amlt = "AMLT-PLN"
        case neu = "NEU-PLN"
        case bob = "BOB-PLN"
        case xrp = "XRP-PLN"
    }
    
    var btc: BTC
    var lml: LML
    var trx: TRX
    var lsk: LSK
    var eth: ETH
    var ltc: LTC
    var zrx: ZRX
    var bsv: BSV
    var amlt: AMLT
    var neu: NEU
    var bob: BOB
    var xrp: XRP
    
}

struct BTC: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct LML: Codable {
    var market: Market
    var time: String?
    var highestBid: String?//, moze miec nulla co z tym zrobic?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct TRX: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct LSK: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct LTC: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct ETH: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct ZRX: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct BSV: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct AMLT: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct NEU: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct BOB: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct XRP: Codable {
    var market: Market
    var time: String?
    var highestBid: String?
    var lowestAsk: String?
    var rate: String
    var previousRate: String
}

struct Market: Codable {
    var code: String
}

