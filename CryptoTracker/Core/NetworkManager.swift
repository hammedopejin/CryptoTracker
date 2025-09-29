//
//  NetworkManager.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import Foundation
import CryptoNetworking

final class NetworkManager {
    static let shared = NetworkManager()
    private let client: APIClient = DefaultAPIClient()

    func fetchCoins(completion: @escaping (Result<[RemoteCoin], Error>) -> Void) {
        let endpoint = APIEndpoint(path: "coins/markets", queryItems: [
            URLQueryItem(name: "vs_currency", value: "usd")
        ])
        client.request(endpoint, completion: completion)
    }
    
    func fetchPriceHistory(for coinID: String, completion: @escaping (Result<PriceHistoryDTO, Error>) -> Void) {
        let endpoint = APIEndpoint(path: "coins/\(coinID)/market_chart", queryItems: [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "days", value: "7")
        ])
        client.request(endpoint, completion: completion)
    }

}
