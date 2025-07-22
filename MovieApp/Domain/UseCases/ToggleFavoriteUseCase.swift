//
//  ToggleFavoriteUseCase.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Combine

protocol ToggleFavoriteUseCase {
    func execute(movieId: Int)-> AnyPublisher<Void, Error>
}

final class ToggleFavoriteUseCaseImpl: ToggleFavoriteUseCase {
    private let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(movieId: Int)-> AnyPublisher<Void, Error> {
        return repository.toggleFavorite(for: movieId)
    }
}

