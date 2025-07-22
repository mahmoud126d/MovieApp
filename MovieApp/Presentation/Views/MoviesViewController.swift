//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import UIKit

class MoviesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = []
    var homeViewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
    }


}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        let movie = movies[indexPath.row]
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
            print("Favorite button tapped for movie")
            self?.homeViewModel.toggleFavorite(for: Int(movie.id))
            
        }

        cell.onCellTapped = {
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            detailVC.selectedMovie = movie
            detailVC.homeViewModel = self.homeViewModel
            self.navigationController?.pushViewController(detailVC, animated: true)
        }

        return cell
    }

    
    
}

