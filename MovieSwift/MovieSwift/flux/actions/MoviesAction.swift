//
//  MoviesAction.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct MoviesActions {
    struct FetchPopular: Action {
        init() {
            APIService.shared.GET(endpoint: .popular, params: nil) {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetPopular(response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct SetPopular: Action {
        let response: PaginatedResponse<Movie>
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
    
    struct SetTopRated: Action {
        let response: PaginatedResponse<Movie>
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
    
    struct SetUpcoming: Action {
        let response: PaginatedResponse<Movie>
    }
}
