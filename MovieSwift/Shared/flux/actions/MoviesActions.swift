//
//  MoviesAction.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUIFlux
import Backend

struct MoviesActions {
    
    // MARK: - Requests
    
    struct FetchMoviesMenuList: AsyncAction {
        let list: MoviesMenu
        let page: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: list.endpoint(), params: ["page": "\(page)",
                "region": AppUserDefaults.region])
            {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetMovieMenuList(page: self.page,
                                        list: self.list,
                                        response: response))
                case let .failure(error):
                    print(error)
                    break
                }
            }
        }
    }
    
    struct FetchDetail: AsyncAction {
        let movie: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .movieDetail(movie: movie),
                                  params: ["append_to_response": "keywords,images",
                                           "include_image_language": "\(Locale.current.languageCode ?? "en"),en,null"])
            {
                (result: Result<Movie, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetDetail(movie: self.movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchRecommended: AsyncAction {
        let movie: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .recommended(movie: movie), params: nil)
            {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetRecommended(movie: self.movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    struct FetchSimilar: AsyncAction {
        let movie: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .similar(movie: movie), params: nil)
            {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetSimilar(movie: self.movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchVideos: AsyncAction {
        let movie: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .videos(movie: movie),
                                  params: nil)
            {
                (result: Result<PaginatedResponse<Video>, APIService.APIError>) in
                switch result {
                case let.success(response):
                    dispatch(SetVideos(movie: self.movie, response: response))
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
            APIService.shared.GET(endpoint: .searchMovie, params: ["query": query, "page": "\(page)"])
            {
                (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
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
    
    struct FetchSearchKeyword: AsyncAction {
        let query: String
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .searchKeyword, params: ["query": query])
            {
                (result: Result<PaginatedResponse<Keyword>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetSearchKeyword(query: self.query, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchMoviesGenre: AsyncAction {
        let genre: Genre
        let page: Int
        let sortBy: MoviesSort
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .discover, params:
                ["with_genres": "\(genre.id)",
                    "page": "\(page)",
                    "sort_by": sortBy.sortByAPI()])
            { (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetMovieForGenre(genre: self.genre, page: self.page, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchMovieReviews: AsyncAction {
        let movie: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .review(movie: movie), params: ["language": "en-US"]) {
                (result: Result<PaginatedResponse<Review>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetMovieReviews(movie: self.movie, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    struct FetchMovieWithCrew: AsyncAction {
        let crew: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .discover, params: ["with_people": "\(crew)"])
            { (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetMovieWithCrew(crew: self.crew, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    
    
    struct FetchMovieWithKeywords: AsyncAction {
        let keyword: Int
        let page: Int
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .discover, params: ["page": "\(page)", "with_keywords": "\(keyword)"])
            { (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetMovieWithKeyword(keyword: self.keyword,
                                                 page: self.page,
                                                 response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct FetchRandomDiscover: AsyncAction {
        var filter: DiscoverFilter?
        
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            var filter = self.filter
            if filter == nil {
                filter = DiscoverFilter.randomFilter()
            }
            APIService.shared.GET(endpoint: .discover, params: filter!.toParams())
            { (result: Result<PaginatedResponse<Movie>, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetRandomDiscover(filter: filter!, response: response))
                case .failure(_):
                    break
                }
            }
        }
    }
    
    struct GenresResponse: Codable {
        let genres: [Genre]
    }
    
    struct FetchGenres: AsyncAction {
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            APIService.shared.GET(endpoint: .genres, params: nil)
            { (result: Result<GenresResponse, APIService.APIError>) in
                switch result {
                case let .success(response):
                    dispatch(SetGenres(genres: response.genres))
                case .failure(_):
                    break
                }
            }

        }
    }
    
    struct SetMovieMenuList: Action {
        let page: Int
        let list: MoviesMenu
        let response: PaginatedResponse<Movie>
    }
    
    struct SetDetail: Action {
        let movie: Int
        let response: Movie
    }
    struct SetRecommended: Action {
        let movie: Int
        let response: PaginatedResponse<Movie>
    }
    struct SetSimilar: Action {
        let movie: Int
        let response: PaginatedResponse<Movie>
    }
    
    struct SetVideos: Action {
        let movie: Int
        let response: PaginatedResponse<Video>
    }
    
    struct KeywordResponse: Codable {
        let id: Int
        let keywords: [Keyword]
    }
    
    struct SetSearch: Action {
        let query: String
        let page: Int
        let response: PaginatedResponse<Movie>
    }
    
    struct SetGenres: Action {
        let genres: [Genre]
    }
    
    struct SetSearchKeyword: Action {
        let query: String
        let response: PaginatedResponse<Keyword>
    }
    
    struct AddToWishlist: Action {
        let movie: Int
    }
    
    struct RemoveFromWishlist: Action {
        let movie: Int
    }
    
    struct AddToSeenList: Action {
        let movie: Int
    }
    
    struct RemoveFromSeenList: Action {
        let movie: Int
    }
    
    struct SetMovieForGenre: Action {
        let genre: Genre
        let page: Int
        let response: PaginatedResponse<Movie>
    }
    
    struct SetMovieWithCrew: Action {
        let crew: Int
        let response: PaginatedResponse<Movie>
    }
    
    struct SetMovieWithKeyword: Action {
        let keyword: Int
        let page: Int
        let response: PaginatedResponse<Movie>
    }
        
    struct ResetRandomDiscover: Action {
        
    }
    
    struct SetRandomDiscover: Action {
        let filter: DiscoverFilter
        let response: PaginatedResponse<Movie>
    }
    
    struct PushRandomDiscover: Action {
        let movie: Int
    }
    
    struct PopRandromDiscover: Action {
        
    }
    
    struct SetMovieReviews: Action {
        let movie: Int
        let response: PaginatedResponse<Review>
    }
    
    struct AddCustomList: Action {
        let list: CustomList
    }
    
    struct EditCustomList: Action {
        let list: Int
        let title: String?
        let cover: Int?
    }
    
    struct AddMovieToCustomList: Action {
        let list: Int
        let movie: Int
    }
    
    struct AddMoviesToCustomList: Action {
        let list: Int
        let movies: [Int]
    }
    
    struct RemoveMovieFromCustomList: Action {
        let list: Int
        let movie: Int
    }
    
    struct RemoveCustomList: Action {
        let list: Int
    }
    
    struct SaveDiscoverFilter: Action {
        let filter: DiscoverFilter
    }
    
    struct ClearSavedDiscoverFilters: Action { }
}
