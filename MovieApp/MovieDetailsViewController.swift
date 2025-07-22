//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    var isFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        isFavorite.toggle()
        updateFavoriteIcon()
    }
    
        private func updateFavoriteIcon() {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
        }else{
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
