//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Macos on 21/07/2025.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource {

    enum Section: Int, CaseIterable {
        case banner
        case moviesOfTheYear
        case topRatedMovies
    }

    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        self.navigationItem.rightBarButtonItem = searchButton
        //setupTopBar()
        setupCollectionView()
    }
    @objc func searchTapped() {
        print("Search icon tapped")
        
    }
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self

        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.register(MovieOftheYearCell.self, forCellWithReuseIdentifier: "MovieCell")
        collectionView.register(TopRatedMovieCell.self, forCellWithReuseIdentifier: "ThumbnailCell")
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard let section = Section(rawValue: sectionIndex) else { return nil }

            switch section {
            case .banner:
                return self.bannerSection()
            case .moviesOfTheYear:
                return self.horizontalSection()
            case .topRatedMovies:
                return self.verticalSection()
            }
        }
    }

    // MARK: - Layout Sections

    func bannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

        return section
    }

    func horizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16)
        section.interGroupSpacing = 12

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                  elementKind: UICollectionView.elementKindSectionHeader,
                                                                  alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }


    func verticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16)
        section.interGroupSpacing = 8

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                  elementKind: UICollectionView.elementKindSectionHeader,
                                                                  alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }


    // MARK: - DataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .banner:
            return 1
        case .moviesOfTheYear:
            return 6
        case .topRatedMovies:
            return 3
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.configure(text: "Watch popular movies 1917")
            return cell
        case .moviesOfTheYear:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieOftheYearCell
            cell.configure(
                title: "Inception",
                rating: "8.8",
                releaseDate: "2010",
                posterImage: UIImage(resource: .inception)
            )
            // Handle favorite toggle
            cell.onFavoriteToggled = {isFavorite in
                print(("Favorite toggled for Inception: \(isFavorite)"))
            }

            // Handle cell tap
            cell.onCellTapped = {
                print("Cell tapped for Inception")
                let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            return cell

        case .topRatedMovies:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath) as! TopRatedMovieCell
            cell.configure(
                title: "Top Movie \(indexPath.item + 1)",
                rating: "8.\(indexPath.item)",
                releaseDate: "2025-0\(indexPath.item + 1)-01",
                posterImage: UIImage(resource: .inception),
                isFavorite: indexPath.item % 2 == 0
            )
            cell.onFavoriteToggle = {
                    print("Favorite tapped on movie at \(indexPath.item)")
                }

            cell.onCellTapped = {
                    print("Cell tapped at \(indexPath.item)")
                let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
                self.navigationController?.pushViewController(detailVC, animated: true)
                }
            return cell

        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let section = Section(rawValue: indexPath.section),
              section != .banner else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as! SectionHeaderView

        header.titleLabel.text = (section == .moviesOfTheYear) ? "Top 2025 Movies" : "Top Rated"
        header.onSeeMoreTapped = {
            print("See more tapped for section: \(section)")
            let moviesVC = self.storyboard?.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
            moviesVC.title = header.titleLabel.text
            self.navigationController?.pushViewController(moviesVC, animated: true)
        }

        return header
    }
}
