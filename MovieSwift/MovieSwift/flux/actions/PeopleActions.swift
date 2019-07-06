//
//  CastsAction.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct PeopleActions {
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
    
    struct FetchSearch: AsyncAction {
        let query: String
        let page: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .searchPerson, params: ["query": query, "page": "\(page)"])
            {
                (result: Result<PaginatedResponse<People>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetSearch(query: self.query,
                                       page: self.page,
                                       response: response))
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
    
    struct SetSearch: Action {
        let query: String
        let page: Int
        let response: PaginatedResponse<People>
    }
    
}
