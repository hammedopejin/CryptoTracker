//
//  DefaultCoinListUseCase.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

final class DefaultCoinListUseCase: CoinListUseCase {
    func fetchCoins(completion: @escaping ([RemoteCoin]) -> Void) {
        NetworkManager.shared.fetchCoins { result in
            DispatchQueue.main.async {
                let coins = PersistenceManager.shared.loadCoinsFallbackIfNeeded(networkResult: result)
                completion(coins)
            }
        }
    }
}
