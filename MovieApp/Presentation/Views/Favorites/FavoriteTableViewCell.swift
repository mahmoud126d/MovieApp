//
//  FavoriteTableViewCell.swift
//  MovieApp
//
//  Created by Macos on 21/07/2025.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    static let identifier = "FavoriteTableViewCell"

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    var onFavoriteTapped: (() -> Void)?
    var onCellTapped: (() -> Void)?

    private var isFavorite: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        addTapGesture()
    }

    private func setupUI() {
        // Style image
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        // Labels
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.textColor = .gray
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false

        // Favorite Button
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemRed
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        // Add subviews
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(favoriteButton)

        // Layout
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),

            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            releaseDateLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    func configure(title: String, rating: String, releaseDate: String, posterImage: UIImage?, isFavorite: Bool) {
        titleLabel.text = title
        ratingLabel.text = "⭐️ \(rating)"
        releaseDateLabel.text = releaseDate
        posterImageView.image = posterImage ?? UIImage(systemName: "photo")
        self.isFavorite = isFavorite
        updateFavoriteIcon()
    }

    @objc private func favoriteTapped() {
        isFavorite.toggle()
        onFavoriteTapped?()
        updateFavoriteIcon()
    }

    private func updateFavoriteIcon() {
        let iconName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGesture)
    }

    @objc private func cellTapped() {
        onCellTapped?()
    }
}
