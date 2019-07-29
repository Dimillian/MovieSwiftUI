//
//  APIService.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct APIService {
    let baseURL = URL(string: "https://api.themoviedb.org/3")!
    let apiKey = "YOUR_KEY" // TODO: Change to your key (https://www.themoviedb.org/account/signup)
    static let shared = APIService()
    let decoder = JSONDecoder()
    
    enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
    enum Endpoint {
        case popular, toRated, upcoming, nowPlaying, trending
        case movieDetail(movie: Int), recommended(movie: Int), similar(movie: Int)
        case credits(movie: Int), review(movie: Int)
        case searchMovie, searchKeyword, searchPerson
        case personDetail(person: Int)
        case personMovieCredits(person: Int)
        case personImages(person: Int)
        case genres
        case discover
        
        func path() -> String {
            switch self {
            case .popular:
                return "movie/popular"
            case .toRated:
                return "movie/top_rated"
            case .upcoming:
                return "movie/upcoming"
            case .nowPlaying:
                return "movie/now_playing"
            case .trending:
                return "trending/movie/day"
            case let .movieDetail(movie):
                return "movie/\(String(movie))"
            case let .personDetail(person):
                return "person/\(String(person))"
            case let .credits(movie):
                return "movie/\(String(movie))/credits"
            case let .review(movie):
                return "movie/\(String(movie))/reviews"
            case let .recommended(movie):
                return "movie/\(String(movie))/recommendations"
            case let .similar(movie):
                return "movie/\(String(movie))/similar"
            case let .personMovieCredits(person):
                return "person/\(person)/movie_credits"
            case let .personImages(person):
                return "person/\(person)/images"
            case .searchMovie:
                return "search/movie"
            case .searchKeyword:
                return "search/keyword"
            case .searchPerson:
                return "search/person"
            case .genres:
                return "genre/movie/list"
            case .discover:
                return "discover/movie"
            }
        }
    }
    
    func GET<T: Codable>(endpoint: Endpoint,
                         params: [String: String]?,
                         completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey),
           URLQueryItem(name: "language", value: Locale.preferredLanguages[0])
        ]
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data,
                let httpResponse = response as? HTTPURLResponse else {
                fatalError("Something is wrong with the request results(optional values)")
            }
            
            switch httpResponse.status.responseType {
            case .success:
                do {
                    let object = try self.decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(.success(object))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        #if DEBUG
                        print("JSON Decoding Error: \(error)")
                        #endif
                        completionHandler(.failure(.jsonDecodingError(error: error)))
                    }
                }
            case .clientError:
                DispatchQueue.main.async {
                    #if DEBUG
                    if httpResponse.status == .unauthorized {
                        print("Did you added your API Key?")
                    }
                    #endif
                    let error = NSError(domain:"networkError", code:httpResponse.statusCode, userInfo:nil)
                    completionHandler(.failure(.networkError(error: error)))
                }
            default: // All other error types
                DispatchQueue.main.async {
                    #if DEBUG
                    print("Server Error Code: \(httpResponse.status.hashValue)")
                    #endif
                    completionHandler(.failure(.noResponse))
                }
            }
        }
        task.resume()
    }
    
}

