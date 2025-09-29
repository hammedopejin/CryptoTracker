//
//  FavoritesViewModel.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [RemoteCoin] = []

    func loadFavorites() {
        favorites = PersistenceManager.shared.fetchFavoriteCoins()
    }

    func removeFavorite(_ coin: RemoteCoin) {
        PersistenceManager.shared.toggleFavorite(for: coin)
        loadFavorites()
    }
}
