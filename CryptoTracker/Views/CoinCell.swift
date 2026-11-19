//
//  CoinCell.swift
//  CryptoTracker
//
//  Created by blackmagic on 9/28/25.
//

import UIKit

final class CoinCell: UITableViewCell {
    static let reuseID = "CoinCell"

    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    private var imageTask: URLSessionDataTask?
    private static var imageCache = NSCache<NSURL, UIImage>()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        imageTask?.cancel()
    }

    private func setup() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.layer.cornerRadius = 20
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
        iconView.backgroundColor = .secondarySystemBackground
        iconView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        priceLabel.textColor = .label
        priceLabel.textAlignment = .right
        
        changeLabel.translatesAutoresizingMaskIntoConstraints = false
        changeLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        
        
        
        
        contentView.addSubview(changeLabel)
        
        contentView.addSubview(priceLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            changeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            changeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }

    func configure(with coin: RemoteCoin) {
        if let price = coin.currentPrice {
            priceLabel.text = "$\(String(format: "%.2f", price))"
        } else {
            priceLabel.text = "-"
        }
        if let pct = coin.changePercent24h {
            changeLabel.text = String(format: "%+.2f%%", pct)
            changeLabel.textColor = pct >= 0 ? .systemGreen: .systemRed
        } else {
            changeLabel.text = "-"
            changeLabel.textColor = .secondaryLabel
        }
        
        nameLabel.text = "\(coin.name) (\(coin.symbol.uppercased()))"

        guard let urlString = coin.image, let url = URL(string: urlString) else {
            iconView.image = UIImage(systemName: "bitcoinsign.circle")
            return
        }

        loadImage(from: url)
    }
    private func formatCompact(_ value: Double) -> String {
        switch value {
        case 1_000_000_000_000...: return String(format: "$%.2fT", value / 1_000_000_000_000)
        case 1_000_000_000...: return String(format: "$%.2fB", value / 1_000_000_000)
        default: return String(format: "$%.2fM", value / 1_000_000)
        }
    }
    private func loadImage(from url: URL) {
        if let cached = CoinCell.imageCache.object(forKey: url as NSURL) {
            iconView.image = cached
            return
        }

        imageTask?.cancel()
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            CoinCell.imageCache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                self?.iconView.image = image
            }
        }
        imageTask?.resume()
    }
}
