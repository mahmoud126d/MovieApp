//
//  ThumbnailCell.swift
//  MovieApp
//
//  Created by Macos on 21/07/2025.
//

import UIKit

class TopRatedMovieCell: UICollectionViewCell {

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    private var isFavorite = false

    // MARK: - Closures
    var onFavoriteToggle: (() -> Void)?
    var onCellTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.textColor = .secondaryLabel

        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.textColor = .secondaryLabel

        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemPink
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -10),

            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            releaseDateLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func favoriteTapped() {
        isFavorite.toggle()
        updateFavoriteButton()
        onFavoriteToggle?()
    }

    private func updateFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tap)
    }

    @objc private func cellTapped() {
        onCellTapped?()
    }

    // MARK: - Public configure
    func configure(title: String, rating: String, releaseDate: String, posterImage: UIImage, isFavorite: Bool = false) {
        titleLabel.text = title
        ratingLabel.text = "⭐️ \(rating)"
        releaseDateLabel.text = "📅 \(releaseDate)"

        posterImageView.image = posterImage
        posterImageView.tintColor = posterImage == nil ? .systemGray3 : nil

        self.isFavorite = isFavorite
        updateFavoriteButton()
    }
}
