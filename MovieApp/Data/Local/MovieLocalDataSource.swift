//
//  MovieLocalDataSource.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import CoreData
import Combine
import UIKit

protocol MovieLocalStorageProtocol {
    func saveMovies(from dtos: [MovieDTO],movieCategory:MovieCategory) -> AnyPublisher<[Movie], Error>
    func loadMovies(movieCategory:MovieCategory) -> AnyPublisher<[Movie], Error>
    func toggleFavorite(for movieID: Int) -> AnyPublisher<Void, Error>
    func fetchFavoriteMovies() -> AnyPublisher<[Movie], Error>
}

final class MovieLocalStorage: MovieLocalStorageProtocol {

    private let context = PersistenceController.shared.context

    func saveMovies(from dtos: [MovieDTO], movieCategory: MovieCategory) -> AnyPublisher<[Movie], Error> {
        Future { promise in
            var movies: [Movie] = []
            for dto in dtos {
                // Skip if movie with same id already exists in Core Data
                let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", dto.id)

                if let existing = try? self.context.fetch(fetchRequest), !existing.isEmpty {
                    continue
                }

                let movie = Movie(context: self.context)



                movie.id = Int64(dto.id)
                movie.title = dto.title
                movie.overview = dto.overview
                movie.releaseDate = dto.releaseDate
                movie.voteAverage = dto.voteAverage
                movie.posterPath = dto.posterPath
                movie.isFavorite = false
                movie.originalLanguage = dto.language
                movie.category = movieCategory.rawValue

                // Download and save poster image if exists
                if let posterPath = dto.posterPath,
                   let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)"),
                   let imageData = try? Data(contentsOf: url) {
                    movie.posterImage = imageData
                }

                movies.append(movie)
            }

            do {
                try self.context.save()
                promise(.success(movies))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }


    func loadMovies(movieCategory: MovieCategory) -> AnyPublisher<[Movie], Error> {
        Future { promise in
            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            
            request.predicate = NSPredicate(format: "category == %@", movieCategory.rawValue)

            do {
                let movies = try self.context.fetch(request)
                promise(.success(movies))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    func fetchFavoriteMovies() -> AnyPublisher<[Movie], Error> {
        Future { promise in
            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            
            request.predicate = NSPredicate(format: "isFavorite == %d", true)

            do {
                let movies = try self.context.fetch(request)
                promise(.success(movies))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
        
        
    }
    func toggleFavorite(for movieID: Int) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NSError(domain: "ContextDeallocated", code: 0)))
            }

            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", movieID)

            do {
                if let movie = try self.context.fetch(request).first {
                    movie.isFavorite.toggle()
                    try self.context.save()
                    promise(.success(()))
                } else {
                    promise(.failure(NSError(domain: "MovieNotFound", code: 404)))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}



final class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "MovieApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}
