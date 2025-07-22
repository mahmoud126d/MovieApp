//
//  FavoritesViewModel.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
 
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private var favoriteViewModel: FavoritesViewModel!
    
    private let fetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    
    init(fetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCase, toggleFavoriteUseCase: ToggleFavoriteUseCase) {
        self.fetchFavoriteMoviesUseCase = fetchFavoriteMoviesUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
    }
    
    func fetchFavoriteMovies() {
        fetchFavoriteMoviesUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print("Fetch error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
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
