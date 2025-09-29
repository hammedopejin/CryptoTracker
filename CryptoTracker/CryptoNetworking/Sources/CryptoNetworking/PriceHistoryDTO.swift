//
//  PriceHistoryDTO.swift
//  CryptoNetworking
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

public struct PriceHistoryDTO: Decodable {
    public let prices: [[Double]] // Each entry is [timestamp, price]

    enum CodingKeys: String, CodingKey {
        case prices
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.prices = try container.decodeIfPresent([[Double]].self, forKey: .prices) ?? []
    }
}
