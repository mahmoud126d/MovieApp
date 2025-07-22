//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
        @Published var topRatedMovies: [Movie] = []
        @Published var moviesOfTheYear: [Movie] = []
        @Published var errorMessage: String?

        private var cancellables = Set<AnyCancellable>()
        private let fetchTopRatedMoviesUseCase: FetchTopRatedMoviesUseCase
        private let fetchMoviesOfTheYearUseCase: FetchMoviesOfTheYearUseCase
        private let toggleFavoriteUseCase: ToggleFavoriteUseCase
        private let appLaunchChecker: AppLaunchChecker
    
    init(fetchTopRatedMoviesUseCase: FetchTopRatedMoviesUseCase, fetchMoviesOfTheYearUseCase: FetchMoviesOfTheYearUseCase,
         toggleFavoriteUseCase: ToggleFavoriteUseCase,
         appLaunchChecker: AppLaunchChecker) {
        self.fetchTopRatedMoviesUseCase = fetchTopRatedMoviesUseCase
        self.fetchMoviesOfTheYearUseCase = fetchMoviesOfTheYearUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.appLaunchChecker = appLaunchChecker
    }

    func fetchMovies() {
        Publishers.Zip(
            fetchTopRatedMoviesUseCase.execute(),
            fetchMoviesOfTheYearUseCase.execute()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case let .failure(error) = completion {
                self?.errorMessage = error.localizedDescription
                print("Combined error: \(error.localizedDescription)")
            }
        } receiveValue: { [weak self] topRated, ofTheYear in
            self?.topRatedMovies = topRated
            self?.moviesOfTheYear = ofTheYear
            self?.appLaunchChecker.markLaunched()
        }
        .store(in: &cancellables)
    }
    func toggleFavorite(for movieID: Int) {
        toggleFavoriteUseCase.execute(movieId: movieID)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("Successfully toggled favorite")
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        print("Error toggling favorite: \(error.localizedDescription)")
                    }
                } receiveValue: {
                    // You can do any success-related logic here if needed
                }
                .store(in: &cancellables)
    }
    
}
