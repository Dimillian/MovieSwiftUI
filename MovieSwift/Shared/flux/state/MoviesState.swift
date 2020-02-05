//
//  MoviesState.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUIFlux

struct MoviesState: FluxState, Codable {
    var movies: [Int: Movie] = [:]
    var moviesList: [MoviesMenu: [Int]] = [:]
    
    var recommended: [Int: [Int]] = [:]
    var similar: [Int: [Int ]] = [:]
    
    var search: [String: [Int]] = [:]
    var searchKeywords: [String: [Keyword]] = [:]
    var recentSearches: Set<String> = Set()
    
    var moviesUserMeta: [Int: MovieUserMeta] = [:]
    
    var discover: [Int] = []
    var discoverFilter: DiscoverFilter?
    var savedDiscoverFilters: [DiscoverFilter] = []
    
    var wishlist: Set<Int> = Set()
    var seenlist: Set<Int> = Set()
    
    var videos: [Int: [Video]] = [:]
    
    var withGenre: [Int: [Int]] = [:]
    var withKeywords: [Int: [Int]] = [:]
    var withCrew: [Int: [Int]] = [:]
    var reviews: [Int: [Review]] = [:]
    
    var customLists: [Int: CustomList] = [:]
    
    var genres: [Genre] = []
    
    enum CodingKeys: String, CodingKey {
        case movies, wishlist, seenlist, customLists, moviesUserMeta, savedDiscoverFilters
    }
}
