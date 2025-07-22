//
//  FetchMoviesOfTheYearUseCase.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import Combine

protocol FetchMoviesOfTheYearUseCase {
    func execute() -> AnyPublisher<[Movie], Error>
}

final class FetchMoviesOfTheYearUseCaseImpl: FetchMoviesOfTheYearUseCase {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Movie], Error> {
        return repository.fetchMoviesOfTheYear()
    }
}
