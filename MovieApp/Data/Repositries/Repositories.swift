//
//  Repositories.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import Combine



final class MovieRepository: MovieRepositoryProtocol {
    
    private let api: MovieAPIServiceProtocol
    private let storage: MovieLocalStorageProtocol
    private let networkMonitor: NetworkMonitor
    private let appLaunchChecker: AppLaunchChecker

    init(api: MovieAPIServiceProtocol,
         storage: MovieLocalStorageProtocol,
         networkMonitor: NetworkMonitor,
         appLaunchChecker: AppLaunchChecker) {
        self.api = api
        self.storage = storage
        self.networkMonitor = networkMonitor
        self.appLaunchChecker = appLaunchChecker
    }

    func fetchTopRatedMovies() -> AnyPublisher<[Movie], Error> {
        let isFirstLaunch = appLaunchChecker.isFirstLaunch
        let isConnected = networkMonitor.isConnected
        
        
        
        if isConnected && isFirstLaunch {
            return api.fetchMovies(moviesCategory: .topRated)
                .flatMap { [storage] dtos in
                    storage.saveMovies(from: dtos,movieCategory: .topRated)
                }
                .catch { _ in self.storage.loadMovies(movieCategory: .topRated) }
                .eraseToAnyPublisher()
        } else {
            return storage.loadMovies(movieCategory: .topRated)
        }
    }
    func fetchMoviesOfTheYear() -> AnyPublisher<[Movie], Error> {
        let isFirstLaunch = appLaunchChecker.isFirstLaunch
        let isConnected = networkMonitor.isConnected

        if isConnected && isFirstLaunch {
            return api.fetchMovies(moviesCategory: .moviesOfTheYear)
                .flatMap { [storage] dtos in
                    storage.saveMovies(from: dtos,movieCategory: .moviesOfTheYear)
                }
                .catch { _ in self.storage.loadMovies(movieCategory: .moviesOfTheYear) }
                .eraseToAnyPublisher()
        } else {
            return storage.loadMovies(movieCategory: .moviesOfTheYear)
        }
    }
    func toggleFavorite(for movieId: Int) -> AnyPublisher<Void, Error> {
        return storage.toggleFavorite(for: movieId)
    }
    func fetchFavoriteMovies() -> AnyPublisher<[Movie], Error> {
        return storage.fetchFavoriteMovies()
    }
}


