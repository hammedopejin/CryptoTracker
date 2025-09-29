//
//  HomeViewController.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import UIKit

final class HomeViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel = CoinListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    weak var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CryptoTracker"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupSearchController()
        setupFavoritesButton()
        bindViewModel()
        viewModel.loadCoins()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.reuseID)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coins"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupFavoritesButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Favorites",
            style: .plain,
            target: self,
            action: #selector(showFavorites)
        )
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    @objc private func showFavorites() {
        coordinator?.showFavorites()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.reuseID, for: indexPath) as! CoinCell
        let coin = viewModel.coin(at: indexPath.row)
        cell.configure(with: coin)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.coin(at: indexPath.row)
        coordinator?.showCoinDetail(for: coin)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.filter(with: query)
    }
}
