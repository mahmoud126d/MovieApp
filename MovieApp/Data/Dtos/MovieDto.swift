//
//  MovieDto.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import UIKit

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case language = "original_language"
    }
}


extension Movie {
    func update(with dto: MovieDTO, imageData: Data?) {
        self.id = Int64(dto.id)
        self.title = dto.title
        self.posterPath = dto.posterPath ?? ""
        self.overview = dto.overview
        self.releaseDate = dto.releaseDate
        self.voteAverage = dto.voteAverage
        self.isFavorite = false
        self.originalLanguage = dto.language ?? ""
        self.posterImage = imageData
    }

    var uiImage: UIImage? {
        guard let data = posterImage else { return nil }
        return UIImage(data: data)
    }
}
