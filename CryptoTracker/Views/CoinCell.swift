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

        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with coin: RemoteCoin) {
        nameLabel.text = "\(coin.name) (\(coin.symbol.uppercased()))"

        guard let urlString = coin.image, let url = URL(string: urlString) else {
            iconView.image = UIImage(systemName: "bitcoinsign.circle")
            return
        }

        loadImage(from: url)
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
