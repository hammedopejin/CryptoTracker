//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import SwiftUI
import Charts

struct CoinDetailView: View {
    @StateObject private var viewModel: CoinDetailViewModel

    init(coin: RemoteCoin) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(viewModel.coin.name)
                    .font(.largeTitle)
                    .bold()

                Text("Symbol: \(viewModel.coin.symbol.uppercased())")
                    .font(.title2)

                Text("ID: \(viewModel.coin.id)")
                    .font(.body)
                    .foregroundColor(.gray)

                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Label(
                        viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                        systemImage: viewModel.isFavorite ? "heart.fill" : "heart"
                    )
                    .font(.headline)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }

                Chart(viewModel.priceHistory) {
                    LineMark(
                        x: .value("Date", $0.date),
                        y: .value("Price", $0.price)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Details")
    }
}
