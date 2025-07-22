//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieOverview: UILabel!
    
    @IBOutlet weak var movieVoteAverage: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieOriginalLanguage: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    var homeViewModel: HomeViewModel!
    var selectedMovie: Movie?
    var isFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateMovieDetails()
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        isFavorite.toggle()
        updateFavoriteIcon()
    }
    
    private func updateFavoriteIcon() {
        homeViewModel.toggleFavorite(for: Int(selectedMovie?.id ?? 0))
        if selectedMovie?.isFavorite == true {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    private func populateMovieDetails(){
        guard let movie = selectedMovie else { return }
        movieTitle.text = movie.title
        movieOverview.text = movie.overview
        movieVoteAverage.text = String(movie.voteAverage)
        movieReleaseDate.text = movie.releaseDate
        movieOriginalLanguage.text = movie.originalLanguage
        if let data = movie.posterImage, let image = UIImage(data: data) {
            movieImage.image = image
        } else {
            movieImage.image = UIImage(named: "placeholder") ?? UIImage()
        }
        if selectedMovie?.isFavorite == true {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
