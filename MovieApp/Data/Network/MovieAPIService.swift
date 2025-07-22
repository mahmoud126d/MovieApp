//
//  MovieAPIService.swift
//  MovieApp
//
//  Created by Macos on 22/07/2025.
//

import Foundation
import Combine
import UIKit

protocol MovieAPIServiceProtocol {
    func fetchMovies(moviesCategory:MovieCategory) -> AnyPublisher<[MovieDTO], Error>
}

final class MovieAPIService: MovieAPIServiceProtocol {
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNDI4OGM1NjQxMmVhN2UyMGYxNGQyYWI2MmEzNmVmYyIsIm5iZiI6MTc1MzExMTA0Ny41NzcsInN1YiI6IjY4N2U1YTA3MDFmN2QwMjQzODhhNGNhMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.a3MarWuaeFbFdNosU4nAkpC2s3vslJSoUNT5ke31F3Y"
    private let topRatedbaseURL = "https://api.themoviedb.org/3/movie/top_rated"
    private let moviesOftheYearbaseURL = "https://api.themoviedb.org/3/discover/movie?primary_release_year=2025&sort_by=vote_average.desc&vote_count.gte=100"

    func fetchMovies(moviesCategory:MovieCategory) -> AnyPublisher<[MovieDTO], Error> {
        let url: URL
        switch moviesCategory {
        case .topRated:
            guard let constructedURL = URL(string: topRatedbaseURL) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            url = constructedURL

        case .moviesOfTheYear:
            guard let constructedURL = URL(string: moviesOftheYearbaseURL) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            url = constructedURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse {
                    print("Status code: \(response.statusCode)")
                    if response.statusCode != 200 {
                        let body = String(data: result.data, encoding: .utf8) ?? "No response body"
                        print("Error body: \(body)")
                        throw URLError(.badServerResponse)
                    }
                }
                return result.data
            }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .eraseToAnyPublisher()

    }

}

struct MovieResponse: Codable {
    let results: [MovieDTO]
}

enum MovieCategory: String{
    case topRated = "top_rated"
    case moviesOfTheYear = "movies_of_the_year"
    
}
