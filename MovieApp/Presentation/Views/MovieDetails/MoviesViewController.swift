//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import UIKit

class MoviesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
    }


}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as! FavoriteTableViewCell
        //let movie = movies[indexPath.row]

        cell.configure(
            title: "Movie Title",
            rating: "8.5",
            releaseDate: "2025-07-21",
            posterImage: UIImage(resource: .inception) ,
            isFavorite: true
        )

        cell.onFavoriteTapped = {
            print("Favorite button tapped for movie")
            
        }

        cell.onCellTapped = {
            print("Tapped cell for movie: ")
            // You can navigate to detail screen here
        }

        return cell
    }

    
    
}

