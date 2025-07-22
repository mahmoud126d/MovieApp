//
//  MovieEntity.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation

struct MovieEntity: Identifiable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let overview: String?
    let originalLanguage: String?
    let category: String?
    var isFavorite: Bool
}
