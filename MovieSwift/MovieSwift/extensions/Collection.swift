//
//  Collection.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

enum MoviesSort {
    case byReleaseDate, byAddedDate, byScore, byPopularity
    
    func title() -> String {
        switch self {
        case .byReleaseDate:
            return "by release date"
        case .byAddedDate:
            return "by added date"
        case .byScore:
            return "by rating"
        case .byPopularity:
            return "by popularity"
        }
    }
    
    func sortByAPI() -> String {
        switch self {
        case .byReleaseDate:
            return "release_date.desc"
        case .byAddedDate:
            return "primary_release_date.desc"
        case .byScore:
            return "vote_average.desc"
        case .byPopularity:
            return "popularity.desc"
        }
    }
}

extension Sequence where Iterator.Element == Int {
    func sortedMoviesIds(by: MoviesSort, state: AppState) -> [Int] {
        switch by {
        case .byAddedDate:
            let metas = state.moviesState.moviesUserMeta.filter{ self.contains($0.key) }
            return metas.sorted{ $0.value.addedToList ?? Date() > $1.value.addedToList ?? Date() }.compactMap{ $0.key }
        case .byReleaseDate:
            let movies = state.moviesState.movies.filter{ self.contains($0.key) }
            return movies.sorted{ $0.value.releaseDate ?? Date() > $1.value.releaseDate ?? Date() }.compactMap{ $0.key }
        case .byPopularity:
            let movies = state.moviesState.movies.filter{ self.contains($0.key) }
            return movies.sorted{ $0.value.popularity > $1.value.popularity }.compactMap{ $0.key }
        case .byScore:
            let movies = state.moviesState.movies.filter{ self.contains($0.key) }
            return movies.sorted{ $0.value.vote_average > $1.value.vote_average }.compactMap{ $0.key }
        }
    }
}
