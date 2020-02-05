//
//  MoviesMenu.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import Backend

enum MoviesMenu: Int, CaseIterable {
    case nowPlaying, upcoming, trending, popular, topRated, genres
    
    func title() -> String {
        switch self {
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        case .nowPlaying: return "Now Playing"
        case .trending: return "Trending"
        case .genres: return "Genres"
        }
    }
    
    func endpoint() -> APIService.Endpoint {
        switch self {
        case .popular: return APIService.Endpoint.popular
        case .topRated: return APIService.Endpoint.topRated
        case .upcoming: return APIService.Endpoint.upcoming
        case .nowPlaying: return APIService.Endpoint.nowPlaying
        case .trending: return APIService.Endpoint.trending
        case .genres: return APIService.Endpoint.genres
        }
    }
}
