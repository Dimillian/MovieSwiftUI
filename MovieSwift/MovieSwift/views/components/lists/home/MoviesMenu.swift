//
//  MoviesMenu.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

enum MoviesMenu: Int, CaseIterable {
    case popular, topRated, upcoming, nowPlaying, trending
    
    func title() -> String {
        switch self {
        case .popular: return "Popular"
        case .topRated: return "Top Rated"
        case .upcoming: return "Upcoming"
        case .nowPlaying: return "Now Playing"
        case .trending: return "Trending"
        }
    }
    
    func endpoint() -> APIService.Endpoint {
        switch self {
        case .popular: return APIService.Endpoint.popular
        case .topRated: return APIService.Endpoint.toRated
        case .upcoming: return APIService.Endpoint.upcoming
        case .nowPlaying: return APIService.Endpoint.nowPlaying
        case .trending: return APIService.Endpoint.trending
        }
    }
}
