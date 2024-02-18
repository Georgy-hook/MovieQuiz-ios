//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Georgy on 24.04.2023.
//

import Foundation
protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
private enum LoaderError: Error {
    case decodeError
}
struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
     private let networkClient: NetworkRouting
     
     init(networkClient: NetworkRouting = NetworkClient()) {
         self.networkClient = networkClient
     }
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/<Your api key>") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl){result in
            switch result{
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(json))
                }
                catch{
                    handler(.failure(LoaderError.decodeError))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
