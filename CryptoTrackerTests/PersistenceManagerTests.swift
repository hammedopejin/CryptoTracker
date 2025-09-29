//
//  PersistenceManagerTests.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import XCTest
@testable import CryptoTracker

final class PersistenceManagerTests: XCTestCase {
    var persistence: PersistenceManager!

    override func setUp() {
        super.setUp()
        persistence = PersistenceManager.makeTestInstance()
    }

    func testToggleFavoriteAddsAndRemovesCoin() {
        let coin = RemoteCoin(id: "testcoin", symbol: "tst", name: "TestCoin", image: nil)

        persistence.toggleFavorite(for: coin)
        XCTAssertTrue(persistence.isFavorite(coin: coin))

        persistence.toggleFavorite(for: coin)
        XCTAssertFalse(persistence.isFavorite(coin: coin))
    }

    func testFetchFavoriteCoinsReturnsCorrectData() {
        let coin = RemoteCoin(id: "favcoin", symbol: "fav", name: "FavoriteCoin", image: nil)
        persistence.toggleFavorite(for: coin)

        let favorites = persistence.fetchFavoriteCoins()
        XCTAssertTrue(favorites.contains(where: { $0.id == coin.id }))
    }
}

