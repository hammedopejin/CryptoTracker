# CryptoTracker

CryptoTracker is a lightweight iOS app for browsing and favoriting cryptocurrencies. It uses Core Data for offline persistence and a clean UIKit interface.

## Features

- Browse top 100 coins with logos
- Favorite coins for quick access
- Offline fallback using Core Data
- Responsive UI with dark mode support

## Architecture

- **UIKit** for UI
- **Core Data** for persistence
- **URLSession** for networking
- **MVVM-ish** structure with use cases

## Folder Structure

See `/CryptoTracker` for organized modules:
- `App/`: App lifecycle
- `Core/`: Networking & persistence
- `Models/`: DTOs and data structs
- `Views/`: UI components
- `CoreData/`: `.xcdatamodeld` file
- `Tests/`: Unit tests

## Testing

Run `PersistenceManagerTests.swift` to verify:
- Favorites toggle
- Fetching stored coins
- In-memory test isolation

## Requirements

- iOS 15+
- Xcode 14+

## Credits

Built with ❤️ by Hammed Opejin
Powered by CoinGecko API

