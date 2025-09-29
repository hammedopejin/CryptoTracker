//
//  CoinDetailViewModel.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

final class CoinDetailViewModel: ObservableObject {
    let coin: RemoteCoin
    @Published var isFavorite: Bool = false
    @Published var priceHistory: [PricePoint] = []

    init(coin: RemoteCoin) {
        self.coin = coin
        self.isFavorite = PersistenceManager.shared.isFavorite(coin: coin)
        self.loadPriceHistory()
    }

    func toggleFavorite() {
        PersistenceManager.shared.toggleFavorite(for: coin)
        isFavorite.toggle()
    }
    
    func loadPriceHistory() {
        NetworkManager.shared.fetchPriceHistory(for: coin.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dto):
                    self?.priceHistory = dto.prices.compactMap { entry in
                        guard entry.count == 2 else { return nil }
                        let timestamp = entry[0] / 1000 // ms to s
                        let date = Date(timeIntervalSince1970: timestamp)
                        let price = entry[1]
                        return PricePoint(date: date, price: price)
                    }
                case .failure(let error):
                    print("Price history fetch failed: \(error)")
                }
            }
        }
    }

}
