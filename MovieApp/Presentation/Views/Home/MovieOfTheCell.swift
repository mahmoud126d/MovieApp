//
//  MovieCell.swift
//  MovieApp
//
//  Created by Macos on 21/07/2025.
//

import UIKit

class MovieOftheYearCell: UICollectionViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    private var isFavorite = false
    
    // Callback to notify parent when favorite status changes
    var onFavoriteToggled: ((Bool) -> Void)?
    
    // Callback to notify parent when cell is tapped
    var onCellTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset cell state for reuse
        isFavorite = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        posterImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
        releaseDateLabel.text = nil
        onFavoriteToggled = nil
        onCellTapped = nil
    }
    
    private func setupUI() {
        // Cell appearance
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        // Add subtle shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        
        // Poster image view
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        posterImageView.backgroundColor = .systemGray5
        
        // Title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .label
        titleLabel.lineBreakMode = .byTruncatingTail
        
        // Rating label
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.systemFont(ofSize: 12)
        ratingLabel.textColor = .systemYellow
        
        // Release date label
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.font = UIFont.systemFont(ofSize: 12)
        releaseDateLabel.textColor = .secondaryLabel
        
        // Favorite button
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemRed
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        favoriteButton.layer.cornerRadius = 12
        favoriteButton.clipsToBounds = true
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        // Horizontal stack: Rating on left, Heart button on right
        let ratingHeartStack = UIStackView(arrangedSubviews: [ratingLabel, favoriteButton])
        ratingHeartStack.axis = .horizontal
        ratingHeartStack.spacing = 4
        ratingHeartStack.alignment = .center
        ratingHeartStack.distribution = .equalSpacing
        ratingHeartStack.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.backgroundColor = .clear
        favoriteButton.backgroundColor = .clear
        ratingHeartStack.backgroundColor = .clear

        // Main vertical stack
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, ratingHeartStack, releaseDateLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.alignment = .fill
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        contentView.addSubview(infoStack)

        NSLayoutConstraint.activate([
            // Poster image
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),

            // Info stack (includes title, rating+heart, release date)
            infoStack.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // Favorite button size
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }



    
    func configure(title: String, rating: String, releaseDate: String, posterImage: UIImage?, isFavorite: Bool = false) {
        titleLabel.text = title
        ratingLabel.text = "⭐️ \(rating)"
        releaseDateLabel.text = "📅 \(releaseDate)"
        
        // Set poster image with fallback
        if let posterImage = posterImage {
            posterImageView.image = posterImage
        } else {
            posterImageView.image = UIImage(systemName: "film.fill")
            posterImageView.tintColor = .systemGray3
        }
        
        // Set favorite state
        self.isFavorite = isFavorite
        updateFavoriteButton()
    }
    
    func configure(title: String, rating: Double, releaseDate: String, posterImage: UIImage?, isFavorite: Bool = false) {
        let ratingString = String(format: "%.1f", rating)
        configure(title: title, rating: ratingString, releaseDate: releaseDate, posterImage: posterImage, isFavorite: isFavorite)
    }
    
    private func updateFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
        
        // Add a subtle animation
        UIView.transition(with: favoriteButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.favoriteButton.setImage(image, for: .normal)
        }, completion: nil)
    }
    
    @objc private func toggleFavorite() {
        isFavorite.toggle()
        updateFavoriteButton()
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Notify parent about the change
        onFavoriteToggled?(isFavorite)
    }
    
    @objc private func cellTapped() {
        // Add visual feedback
        animateCellTap()
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Notify parent about the tap
        onCellTapped?()
    }
    
    private func animateCellTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.contentView.transform = CGAffineTransform.identity
            }
        }
    }
    
    // Public method to update favorite state without triggering callback
    func setFavorite(_ favorite: Bool, animated: Bool = true) {
        guard isFavorite != favorite else { return }
        
        isFavorite = favorite
        
        if animated {
            updateFavoriteButton()
        } else {
            let imageName = isFavorite ? "heart.fill" : "heart"
            favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
}

// MARK: - Accessibility
extension MovieOftheYearCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAccessibility()
    }
    
    private func setupAccessibility() {
        // Make the cell accessible
        isAccessibilityElement = false
        accessibilityElements = [titleLabel, ratingLabel, releaseDateLabel, favoriteButton]
        
        // Set accessibility labels
        favoriteButton.accessibilityLabel = "Favorite"
        favoriteButton.accessibilityHint = "Double tap to toggle favorite status"
        
        // Cell accessibility
        contentView.accessibilityLabel = "Movie cell"
        contentView.accessibilityHint = "Double tap to view movie details"
        contentView.accessibilityTraits = .button
        
        titleLabel.accessibilityTraits = .staticText
        ratingLabel.accessibilityTraits = .staticText
        releaseDateLabel.accessibilityTraits = .staticText
        favoriteButton.accessibilityTraits = .button
    }
}
