//
//  CastsAction.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUIFlux
import Backend

struct PeopleActions {
    struct FetchDetail: AsyncAction {
        let people: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .personDetail(person: people), params: nil)
            { (result: Result<People, APIService.APIError>) in
                switch result {
                case let .success(response):
                   dispatch(SetDetail(person: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct ImagesResponse: Codable {
        let id: Int
        let profiles: [ImageData]
    }
    
    struct FetchImages: AsyncAction {
        let people: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .personImages(person: people), params: nil)
            { (result: Result<ImagesResponse, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetImages(people: self.people, images: response.profiles))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct PeopleCreditsResponse: Codable {
        let cast: [Movie]?
        let crew: [Movie]?
    }
    struct FetchPeopleCredits: AsyncAction {
        let people: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .personMovieCredits(person: people), params: nil) {
                (result: Result<PeopleCreditsResponse, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetPeopleCredits(people: self.people, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
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
    
    struct FetchPopular: AsyncAction {
        let page: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .popularPersons, params: ["page": "\(page)",
                "region": AppUserDefaults.region])
            {
                (result: Result<PaginatedResponse<People>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetPopular(page: self.page,
                                        response: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct SetDetail: Action {
        let person: People
    }
    
    struct SetImages: Action {
        let people: Int
        let images: [ImageData]
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
    
    struct SetPopular: Action {
        let page: Int
        let response: PaginatedResponse<People>
    }
    
    struct SetPeopleCredits: Action {
        let people: Int
        let response: PeopleCreditsResponse
    }
    
    struct AddToFanClub: Action {
        let people: Int
    }
    
    struct RemoveFromFanClub: Action {
        let people: Int
    }
}
