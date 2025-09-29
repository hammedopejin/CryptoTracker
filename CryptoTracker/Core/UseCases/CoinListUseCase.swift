//
//  CoinListUseCase.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

protocol CoinListUseCase {
    func fetchCoins(completion: @escaping ([RemoteCoin]) -> Void)
}
