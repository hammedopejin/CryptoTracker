//
//  PersistenceManager.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import Foundation
import CoreData

final class PersistenceManager {
    static let shared = PersistenceManager()

    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext { container.viewContext }

    // MARK: - Init

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CryptoTrackerModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            } else {
                print("Core Data store loaded: \(self.container.persistentStoreDescriptions.first!)")
            }
        }
    }

    static func makeTestInstance() -> PersistenceManager {
        return PersistenceManager(inMemory: true)
    }

    // MARK: - Favorites

    func toggleFavorite(for coin: RemoteCoin) {
        if isFavorite(coin: coin) {
            removeFavorite(coin: coin)
        } else {
            saveFavorite(coin: coin)
        }
    }

    func isFavorite(coin: RemoteCoin) -> Bool {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "FavoriteCoin")
        request.predicate = NSPredicate(format: "id == %@", coin.id)
        request.fetchLimit = 1

        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print("isFavorite error: \(error)")
            return false
        }
    }

    func fetchFavoriteCoins() -> [RemoteCoin] {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "FavoriteCoin")

        do {
            let storedCoins = try context.fetch(request)
            return storedCoins.compactMap {
                RemoteCoin(
                    id: $0.value(forKey: "id") as? String ?? "",
                    symbol: $0.value(forKey: "symbol") as? String ?? "",
                    name: $0.value(forKey: "name") as? String ?? "",
                    image: $0.value(forKey: "image") as? String
                )
            }
        } catch {
            print("fetchFavoriteCoins error: \(error)")
            return []
        }
    }

    // MARK: - Coin List Fallback

    func loadCoinsFallbackIfNeeded(networkResult: Result<[RemoteCoin], Error>) -> [RemoteCoin] {
        switch networkResult {
        case .success(let coins):
            saveCoinsToCoreData(coins)
            return coins
        case .failure(let error):
            print("Network failed: \(error). Loading coins from Core Data.")
            return fetchStoredCoins()
        }
    }

    private func saveCoinsToCoreData(_ coins: [RemoteCoin]) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "StoredCoin")
        do {
            let existing = try context.fetch(fetchRequest)
            for coin in existing {
                context.delete(coin)
            }
        } catch {
            print("Failed to clear old coins: \(error)")
        }

        for coin in coins {
            let stored = NSEntityDescription.insertNewObject(forEntityName: "StoredCoin", into: context)
            stored.setValue(coin.id, forKey: "id")
            stored.setValue(coin.symbol, forKey: "symbol")
            stored.setValue(coin.name, forKey: "name")
            stored.setValue(coin.image, forKey: "image")
        }

        saveContext()
        print("Saved \(coins.count) coins to Core Data")
    }

    private func fetchStoredCoins() -> [RemoteCoin] {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "StoredCoin")
        do {
            let storedCoins = try context.fetch(request)
            return storedCoins.compactMap {
                RemoteCoin(
                    id: $0.value(forKey: "id") as? String ?? "",
                    symbol: $0.value(forKey: "symbol") as? String ?? "",
                    name: $0.value(forKey: "name") as? String ?? "",
                    image: $0.value(forKey: "image") as? String
                )
            }
        } catch {
            print("Failed to fetch stored coins: \(error)")
            return []
        }
    }

    // MARK: - Private Helpers

    private func saveFavorite(coin: RemoteCoin) {
        let stored = NSEntityDescription.insertNewObject(forEntityName: "FavoriteCoin", into: context)
        stored.setValue(coin.id, forKey: "id")
        stored.setValue(coin.symbol, forKey: "symbol")
        stored.setValue(coin.name, forKey: "name")
        stored.setValue(coin.image, forKey: "image")

        saveContext()
    }

    private func removeFavorite(coin: RemoteCoin) {
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "FavoriteCoin")
        request.predicate = NSPredicate(format: "id == %@", coin.id)

        do {
            let results = try context.fetch(request)
            for object in results {
                context.delete(object)
            }
            saveContext()
        } catch {
            print("removeFavorite error: \(error)")
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("saveContext error: \(error)")
            }
        }
    }
}
