//
//  CoinListViewModel.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

final class CoinListViewModel {
    private let useCase: CoinListUseCase
    private(set) var coins: [RemoteCoin] = []
    private(set) var filteredCoins: [RemoteCoin] = []
    var onDataUpdated: (() -> Void)?

    init(useCase: CoinListUseCase = DefaultCoinListUseCase()) {
        self.useCase = useCase
    }

    func loadCoins() {
        useCase.fetchCoins { [weak self] coins in
            self?.coins = coins
            self?.filteredCoins = coins
            self?.onDataUpdated?()
        }
    }

    func coin(at index: Int) -> RemoteCoin {
        return filteredCoins[index]
    }

    var count: Int {
        return filteredCoins.count
    }

    func filter(with query: String) {
        if query.isEmpty {
            filteredCoins = coins
        } else {
            filteredCoins = coins.filter {
                $0.name.lowercased().contains(query.lowercased()) ||
                $0.symbol.lowercased().contains(query.lowercased())
            }
        }
        onDataUpdated?()
    }
}

