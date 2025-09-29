//
//  FavoritesView.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favorites, id: \.id) { coin in
                    HStack {
                        NavigationLink(destination: CoinDetailView(coin: coin)) {
                            Text("\(coin.name) (\(coin.symbol.uppercased()))")
                                .font(.headline)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.removeFavorite(coin)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
}
