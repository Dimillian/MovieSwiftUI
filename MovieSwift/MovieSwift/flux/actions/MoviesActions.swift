//
//  MoviesAction.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct MoviesActions {
    
    // MARK: - Requests
    
    struct FetchPopular: Action {
        init(page: Int) {
            APIService.shared.GET(endpoint: .popular, params: ["page": "\(page)"]) {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetPopular(page: page, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchTopRated: Action {
        init() {
            APIService.shared.GET(endpoint: .toRated, params: nil) {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetTopRated(response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchUpcoming: Action {
        init() {
            APIService.shared.GET(endpoint: .upcoming, params: ["region": "US"]) {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetUpcoming(response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchDetail: Action {
        init(movie: Int) {
            APIService.shared.GET(endpoint: .detail(movie: movie), params: nil) {
                (result: Result<Movie, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetDetail(movie: movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchRecommanded: Action {
        init(movie: Int) {
            APIService.shared.GET(endpoint: .recommanded(movie: movie), params: nil) {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetRecommanded(movie: movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    struct FetchSimilar: Action {
        init(movie: Int) {
            APIService.shared.GET(endpoint: .similar(movie: movie), params: nil) {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetSimilar(movie: movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
   
    
    struct FetchSearch: Action {
        init(query: String) {
            APIService.shared.GET(endpoint: .searchMovie, params: ["query": query]) {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetSearch(query: query, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchSearchKeyword: Action {
        init(query: String) {
            APIService.shared.GET(endpoint: .searchKeyword, params: ["query": query]) {
                (result: Result<PaginatedResponse<Keyword>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetSearchKeyword(query: query, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchMoviesGenre: Action {
        init(genre: Genre) {
            APIService.shared.GET(endpoint: .discover, params: ["with_genres": "\(genre.id)"])
            { (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetMovieForGenre(genre: genre, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchMovieReviews: Action {
        init(movie: Int) {
            APIService.shared.GET(endpoint: .review(movie: movie), params: nil) {
                (result: Result<PaginatedResponse<Review>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetMovieReviews(movie: movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    struct FetchMovieWithCrew: Action {
        init(crew: Int) {
            APIService.shared.GET(endpoint: .discover, params: ["with_people": "\(crew)"])
            { (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetMovieWithCrew(crew: crew, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    
    struct FetchMovieKeywords: Action {
        init(movie: Int) {
            APIService.shared.GET(endpoint: .keywords(movie: movie), params: nil) {
                (result: Result<KeywordResponse, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetMovieKeywords(movie: movie, keywords: response.keywords))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchMovieWithKeywords: Action {
        init(keyword: Int) {
            APIService.shared.GET(endpoint: .discover, params: ["with_keywords": "\(keyword)"])
            { (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetMovieWithKeyword(keyword: keyword, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    // MARK: - Reduced actions
    
    struct SetPopular: Action {
        let page: Int
        let response: PaginatedResponse<Movie>
    }
    struct SetTopRated: Action {
        let response: PaginatedResponse<Movie>
    }
    
    struct SetUpcoming: Action {
        let response: PaginatedResponse<Movie>
    }
    struct SetDetail: Action {
        let movie: Int
        let response: Movie
    }
    struct SetRecommanded: Action {
        let movie: Int
        let response: PaginatedResponse<Movie>
    }
    struct SetSimilar: Action {
        let movie: Int
        let response: PaginatedResponse<Movie>
    }
    struct KeywordResponse: Codable {
        let id: Int
        let keywords: [Keyword]
    }
    
    struct SetMovieKeywords: Action {
        let movie: Int
        let keywords: [Keyword]
    }

    struct SetSearch: Action {
        let query: String
        let response: PaginatedResponse<Movie>
    }
    
    struct SetSearchKeyword: Action {
        let query: String
        let response: PaginatedResponse<Keyword>
    }
    
    struct addToWishlist: Action {
        let movie: Int
    }
    
    struct removeFromWishlist: Action {
        let movie: Int
    }
    
    struct addToSeenlist: Action {
        let movie: Int
    }
    
    struct removeFromSeenlist: Action {
        let movie: Int
    }
    
    struct SetMovieForGenre: Action {
        let genre: Genre
        let response: PaginatedResponse<Movie>
    }
    
    struct SetMovieWithCrew: Action {
        let crew: Int
        let response: PaginatedResponse<Movie>
    }
    
    struct SetMovieWithKeyword: Action {
        let keyword: Int
        let response: PaginatedResponse<Movie>
    }
    
    struct SetMovieReviews: Action {
        let movie: Int
        let response: PaginatedResponse<Review>
    }
    
    struct AddCustomList: Action {
        let list: CustomList
    }
    
    struct EditCustomList: Action {
        let list: UUID
        let name: String?
        let cover: Int?
    }
    
    struct AddMovieToCustomList: Action {
        let list: UUID
        let movie: Int
    }
    
    struct RemoveMovieFromCustomList: Action {
        let list: UUID
        let movie: Int
    }
    
    struct RemoveCustomList: Action {
        let list: UUID
    }
}
