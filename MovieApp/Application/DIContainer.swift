//
//  DIContainer.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private var dependencies: [String: Any] = [:]
    
    private init() {
        registerDependencies()
    }
    
    func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        dependencies[key] = instance
    }

    func resolve<T>(_ type: T.Type = T.self) -> T {
        let key = String(describing: type)
        guard let dependency = dependencies[key] as? T else {
            fatalError("No dependency found for \(key)")
        }
        return dependency
    }

    private func registerDependencies() {
            let networkMonitor = NetworkMonitor()
            let apiService = MovieAPIService()
            let storage = MovieLocalStorage()
            let appLaunchChecker = AppLaunchChecker()

            let repository = MovieRepository(
                api: apiService,
                storage: storage,
                networkMonitor: networkMonitor,
                appLaunchChecker: appLaunchChecker
            )
        register(HomeViewModel.self,
                 instance: HomeViewModel(
                    fetchTopRatedMoviesUseCase: FetchTopRatedMoviesUseCaseImpl(repository: repository), fetchMoviesOfTheYearUseCase: FetchMoviesOfTheYearUseCaseImpl(repository: repository), toggleFavoriteUseCase: ToggleFavoriteUseCaseImpl(repository: repository),
                    appLaunchChecker: AppLaunchChecker(userDefaults: UserDefaults.standard))
        )
        register(FavoritesViewModel.self,
                 instance:  FavoritesViewModel(fetchFavoriteMoviesUseCase: FetchFavoriteMoviesUseCaseImpl(repository: repository), toggleFavoriteUseCase: ToggleFavoriteUseCaseImpl(repository: repository))
        )

    }
}
