//
//  Collection.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

enum MoviesSort {
    enum AddedTo {
        case wishlist, seenlist
    }
    case byReleaseDate, byAdded(to: AddedTo)
}

extension Sequence where Iterator.Element == Int {
    func sortedMoviesIds(by: MoviesSort, state: AppState) -> [Int] {
        switch by {
        case let .byAdded(to):
            let metas = state.moviesState.moviesUserMeta.filter{ self.contains($0.key) }
            switch to {
            case .wishlist:
                return metas.sorted{ $0.value.dateAddedToWishlist ?? Date() > $1.value.dateAddedToWishlist ?? Date() }.compactMap{ $0.key }
            case .seenlist:
                return metas.sorted{ $0.value.dateAddedToSeenList ?? Date() > $1.value.dateAddedToSeenList ?? Date() }.compactMap{ $0.key }
            }
        case .byReleaseDate:
            let movies = state.moviesState.movies.filter{ self.contains($0.key) }
            return movies.sorted{ $0.value.releaseDate ?? Date() > $1.value.releaseDate ?? Date() }.compactMap{ $0.key }
        }
    }
}
