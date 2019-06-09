//
//  CastsAction.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct CastsActions {
    struct FetchMovieCasts: Action {
        init(movie: Int) {
            APIService.shared.GET(endpoint: .credits(movie: movie), params: nil) {
                (result: Result<CastResponse, APIService.APIError>) in
                switch result {
                case let .success(response):
                    store.dispatch(action: SetMovieCasts(movie: movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct SetMovieCasts: Action {
        let movie: Int
        let response: CastResponse
    }
}
