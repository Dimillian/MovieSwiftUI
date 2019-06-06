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
    let apiKey = "1d9b898a212ea52e283351e521e17871"
    static let shared = APIService()
    let decoder = JSONDecoder()
    
    enum APIError: Error {
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
    enum Endpoint {
        case popular
        
        func path() -> String {
            switch self {
            case .popular:
                return "movie/popular"
            }
        }
    }
    
    func GET<T: Codable>(endpoint: Endpoint,
                         params: [String: String]?,
                         completionHandler: @escaping (Result<T, APIError>) -> Void) {
        let queryURL = baseURL.appendingPathComponent(endpoint.path())
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey)
        ]
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.noResponse))
                return
            }
            guard error == nil else {
                completionHandler(.failure(.networkError(error: error!)))
                return
            }
            do {
                let object = try self.decoder.decode(T.self, from: data)
                completionHandler(.success(object))
            } catch let error {
                completionHandler(.failure(.jsonDecodingError(error: error)))
            }
        }
        task.resume()
    }
}

