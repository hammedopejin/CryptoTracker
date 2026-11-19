//
//  CoinDetailView.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import SwiftUI
import Charts

struct CoinDetailView: View {
    @State private var showSupplyTooltip = false
    @AppStorage("suppltTooltipShown") private var supplyTooltipShown: Bool = false
    @StateObject private var viewModel: CoinDetailViewModel
    @State private var appear = false
    @State private var pulse = false

    init(coin: RemoteCoin) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }

    var body: some View {
       
        ScrollView {
            
            VStack(spacing: 16) {
                
                Text(viewModel.coin.name)
                    .font(.largeTitle)
                    .bold()
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                            pulse = true
                        }
                    }
                Text("Symbol: \(viewModel.coin.symbol.uppercased())")
                    .font(.title2)

                Text("ID: \(viewModel.coin.id)")
                    .font(.body)
                    .foregroundColor(.gray)
                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("All-Time High")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if let ath = viewModel.coin.ath {
                            Text(String(format: "$%.2f", ath))
                                .font(.headline)
                        } else {
                            Text("-").font(.headline)
                        }
                        if let d = viewModel.coin.athDate {
                            Text(String(d.prefix(10)))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("All-Time Low")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if let atl = viewModel.coin.atl {
                            Text(String(format: "$%.2f", atl))
                                .font(.headline)
                        } else {
                            Text("-").font(.headline)
                        }
                        if let d = viewModel.coin.atlDate {
                            Text(String(d.prefix(10)))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("24h Volume")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if let vol = viewModel.coin.totalVolume {
                            Text(formatCompact(vol))
                                .font(.headline)
                        } else {
                            Text("-").font(.headline)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("From ATH")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if let changePercent = viewModel.coin.athChangePercent {
                            Text(String(format: "%+.1f%%", changePercent))
                                .font(.headline)
                                .foregroundColor(changePercent >= 0 ? .green : .red)
                        } else {
                            Text("-").font(.headline)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                HStack {
                    Text("From ATL")
                        .font(.caption)
                        .foregroundColor(.gray)
                    if let changePercent = viewModel.coin.atlChangePercent {
                        Text(String(format: "%+.1f%%", changePercent))
                            .font(.headline)
                            .foregroundColor(changePercent >= 0 ? .green : .red)
                    } else {
                        Text("-").font(.headline)
                    }
                    VStack(alignment: .leading) {
                        Text("Market Cap")
                            .font(.caption)
                            .foregroundColor(.gray)
                        if let marketCap = viewModel.coin.marketCap {
                            Text(formatCompact(marketCap))
                                .font(.headline)
                        } else {
                            Text("-").font(.headline)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .onAppear {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        appear = true
                    }
                }
                HStack {
                    Text("24h Range")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Spacer()
                    if let high = viewModel.coin.high24h, let low = viewModel.coin.low24h {
                        HStack(spacing: 8) {
                            Text(formatPrice(low))
                                .font(.headline)
                                .foregroundColor(.red)
                            HStack(spacing: 4)  {
                                Image(systemName: viewModel.coin.changePercent24h  ?? 0 >= 0 ? "arrow.up" : "arrow.down")
                                .font(.caption)
                                .foregroundColor(viewModel.coin.changePercent24h  ?? 0 >= 0 ? .green : .red)
                                if let pct = viewModel.coin.changePercent24h {
                                    Text(String(format: "%+.1f%%", pct))
                                        .font(.caption)
                                        .foregroundColor(viewModel.coin.changePercent24h ?? 0 >= 0 ? .green : .red)
                                }
                        }
                            Text(formatPrice(high))
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    } else {
                        Text("-").font(.headline).foregroundColor(.secondary)
                    }
                }
                .scaleEffect(appear ? 1.0 : 0.8)
                .opacity(appear ? 1.0 : 0.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: appear)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                HStack {
                    Text("Circulating Supply")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    if !supplyTooltipShown {
                        Image(systemName: "info.circle")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .scaleEffect(pulse ? 1.15 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
                    }
                    Spacer()
                    if let supply = viewModel.coin.circulatingSupply {
                        Text(formatCompactM(supply))
                            .font(.headline)
                        if let total = viewModel.coin.totalSupply, total > 0 {
                            Text(String(format: "%.0f%%", (supply / total) * 100))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("-").font(.headline)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        showSupplyTooltip.toggle()
                        supplyTooltipShown = true
                        if showSupplyTooltip {
                            UISelectionFeedbackGenerator().selectionChanged()
                        } else {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                    }
                }
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                        if let supply = viewModel.coin.circulatingSupply,
                           let total = viewModel.coin.totalSupply,
                           total > 0
                        {
                            let fraction = min(max(supply / total, 0), 1)
                            Capsule()
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * CGFloat(fraction))
                        }
                    }
                }
                .frame(height: 6)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                if showSupplyTooltip {
                    Text("Circulatiing supply is the number of coins currently available for trading. Total supply includes all coins ever issued, including those locked or reserved. The difference shows how much more might be unlocked over time.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.top, 6)
                        .opacity(showSupplyTooltip ? 1.0 : 0.0)
                        .offset(y: showSupplyTooltip ? 0 : -8)
                }
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
    private func formatCompact(_ value: Double) -> String {
        switch value {
        case 1_000_000_000_000...: return String(format: "$%.2fT", value / 1_000_000_000_000)
        case 1_000_000_000...: return String(format: "$%.2fB", value / 1_000_000_000)
        default: return String(format: "$%.2fM", value / 1_000_000)
        }
    }
    private func formatCompactM(_ value: Double) -> String {
        switch value {
        case 1_000_000_000_000...: return String(format: "%.2fT", value / 1_000_000_000_000)
        case 1_000_000_000...: return String(format: "%.2fB", value / 1_000_000_000)
        default: return String(format: "%.2fM", value / 1_000_000)
        }
    }
    private func formatPrice(_ value: Double) -> String {
        if  value < 1 {
            return String(format: "$%.4f", value)
        }
        return String(format: "$%.2f", value)
    }
}
