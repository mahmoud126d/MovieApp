//
//  FetchFavoriteMoviesUseCase.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import Combine

protocol FetchFavoriteMoviesUseCase {
    func execute() -> AnyPublisher<[Movie], Error>
}

final class FetchFavoriteMoviesUseCaseImpl: FetchFavoriteMoviesUseCase {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Movie], Error> {
        return repository.fetchFavoriteMovies()
    }
}
