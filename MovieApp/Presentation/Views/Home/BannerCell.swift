//
//  BannerCell.swift
//  MovieApp
//
//  Created by Macos on 21/07/2025.
//

import UIKit

class BannerCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemPurple
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }

    func configure(text: String) {
        label.text = text
    }

    required init?(coder: NSCoder) { fatalError() }
}
