//
//  APIEndpoint.swift
//  CryptoNetworking
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

public struct APIEndpoint {
    public let path: String
    public let queryItems: [URLQueryItem]

    public init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }

    public var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/\(path)"
        components.queryItems = queryItems
        return components.url
    }
}
