//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import Combine

protocol MovieRepositoryProtocol {
    func fetchTopRatedMovies() -> AnyPublisher<[Movie], Error>
    func fetchMoviesOfTheYear() -> AnyPublisher<[Movie], Error>
    func toggleFavorite(for movieId: Int) -> AnyPublisher<Void, Error>
    //func fetchFavoriteMovies() -> AnyPublisher<[Movie], Error>
}

