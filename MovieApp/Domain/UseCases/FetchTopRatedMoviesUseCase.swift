//
//  FetchMoviesUseCase.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Combine

protocol FetchTopRatedMoviesUseCase {
    func execute() -> AnyPublisher<[Movie], Error>
}

final class FetchTopRatedMoviesUseCaseImpl: FetchTopRatedMoviesUseCase {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Movie], Error> {
        return repository.fetchTopRatedMovies()
    }
}
