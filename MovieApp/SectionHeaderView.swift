//
//  SectionHeaderView.swift
//  MovieApp
//
//  Created by Macos on 21/07/2025.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "top 2025 movies"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var onSeeMoreTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(seeMoreButton)

        seeMoreButton.addTarget(self, action: #selector(handleSeeMoreTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            seeMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            seeMoreButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func handleSeeMoreTapped() {
        onSeeMoreTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

