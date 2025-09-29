//
//  AppCoordinator.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import UIKit
import SwiftUI

final class AppCoordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: false)
    }

    func showCoinDetail(for coin: RemoteCoin) {
        let detailView = CoinDetailView(coin: coin)
        let hostingVC = UIHostingController(rootView: detailView)
        navigationController.pushViewController(hostingVC, animated: true)
    }
    
    func showFavorites() {
        let favoritesView = FavoritesView()
        let hostingVC = UIHostingController(rootView: favoritesView)
        navigationController.pushViewController(hostingVC, animated: true)
    }

}
