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

    public init(id: String, symbol: String, name: String, image: String? = nil) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
    }
}
