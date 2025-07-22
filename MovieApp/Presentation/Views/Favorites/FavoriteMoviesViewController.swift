//
//  FavoriteMoviesViewController.swift
//  MovieApp
//
//  Created by Macos on 21/07/2025.
//

import UIKit
import Combine

class FavoriteMoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = []
    var favoritesViewModel: FavoritesViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewWillAppear(_ animated: Bool) {
        
        favoritesViewModel.$movies
                    .receive(on: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.tableView.reloadData()
                    }
                    .store(in: &cancellables)
        favoritesViewModel.fetchFavoriteMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoriteViewModel()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        title = "Favorite Movies"
    }
    
    private func setupFavoriteViewModel() {
        favoritesViewModel = DIContainer.shared.resolve(FavoritesViewModel.self)
    }

}

extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        let movie = favoritesViewModel.movies[indexPath.row]
        let posterImage: UIImage

        if let data = movie.posterImage, let image = UIImage(data: data) {
            posterImage = image
        } else {
            posterImage = UIImage(named: "placeholder") ?? UIImage()
        }

        cell.configure(
            title: movie.title ?? "N/A",
            rating: movie.voteAverage.description,
            releaseDate: movie.releaseDate ?? "N/A",
            posterImage: posterImage,
            isFavorite: movie.isFavorite
        )

        cell.onFavoriteTapped = {[weak self] in
            self?.favoritesViewModel.toggleFavorite(for: Int(movie.id))
            self?.favoritesViewModel.fetchFavoriteMovies()
            self?.tableView.reloadData()
        }

        // Handle cell tap
        cell.onCellTapped = {
            print("Cell tapped for Inception")
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            detailVC.selectedMovie = movie
            detailVC.homeViewModel = DIContainer.shared.resolve(HomeViewModel.self)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

        return cell
    }

    
    
}

        
