//
//  MoviesMenu.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

enum MoviesMenu: Int, CaseIterable {
    case popular, genres
    
    func title() -> String {
        switch self {
        case .popular: return "Popular"
        case .genres: return "Genres"
        }
    }
    
    func endpoint() -> APIService.Endpoint {
        switch self {
        case .popular: return APIService.Endpoint.popular
        case .genres: return APIService.Endpoint.genres
        }
    }
}
