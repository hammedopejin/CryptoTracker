//
//  RemoteCoin.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

public struct RemoteCoin: Decodable {
    public let id: String
    public let symbol: String
    public let name: String
    public let image: String?
    public let currentPrice: Double?
    public let changePercent24h: Double?
    public let marketCap: Double?
    public let ath: Double?
    public let atl: Double?
    public let totalVolume: Double?
    public let athChangePercent: Double?
    public let atlChangePercent: Double?
    public let athDate: String?
    public let atlDate: String?
    public let high24h: Double?
    public let low24h: Double?
    public let circulatingSupply: Double?
    public let totalSupply: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case changePercent24h = "price_change_percentage_24h"
        case marketCap = "market_cap"
        case ath = "ath"
        case atl = "atl"
        case totalVolume = "total_volume"
        case athChangePercent = "ath_change_percentage"
        case atlChangePercent = "atl_change_percentage"
        case athDate = "ath_date"
        case atlDate = "atl_date"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
    }

    public init(id: String, symbol: String, name: String, image: String? = nil, currentPrice: Double? = nil, changePercent24h: Double? = nil, marketCap: Double? = nil, ath: Double? = nil, atl: Double? = nil, totalVolume: Double? = nil, athChangePercent: Double? = nil, atlChangePercent: Double? = nil, athDate: String? = nil, atlDate: String? = nil, high24h: Double? = nil, low24h: Double? = nil, circulatingSupply: Double? = nil, totalSupply: Double? = nil) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.changePercent24h = changePercent24h
        self.marketCap = marketCap
        self.ath = ath
        self.atl = atl
        self.totalVolume = totalVolume
        self.athChangePercent = athChangePercent
        self.atlChangePercent = atlChangePercent
        self.athDate = athDate
        self.atlDate = atlDate
        self.high24h = high24h
        self.low24h = low24h
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
    }
}
