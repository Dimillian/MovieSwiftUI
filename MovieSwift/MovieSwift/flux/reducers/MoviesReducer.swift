//
//  MoviesStateReducer.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation

struct MoviesReducer: Reducer {
    func reduce(state: MoviesState, action: Action) -> MoviesState {
        var state = state
        if let action = action as? MoviesActions.SetPopular {
            state.popular = action.response.results.map{ $0.id }
            for (_, value) in action.response.results.enumerated() {
                state.movies[value.id] = value
            }
        } else if let action = action as? MoviesActions.SetTopRated {
            state.topRated = action.response.results.map{ $0.id }
            for (_, value) in action.response.results.enumerated() {
                state.movies[value.id] = value
            }
        } else if let action = action as? MoviesActions.SetUpcoming {
            state.upcoming = action.response.results.map{ $0.id }
            for (_, value) in action.response.results.enumerated() {
                state.movies[value.id] = value
            }
        } else if let action = action as? MoviesActions.SetDetail {
            state.movies[action.movie] = action.response
        } else if let action = action as? MoviesActions.SetRecommanded {
            state.recommanded[action.movie] = action.response.results.map{ $0.id }
            for (_, value) in action.response.results.enumerated() {
                state.movies[value.id] = value
            }
        } else if let action = action as? MoviesActions.SetSimilar {
            state.similar[action.movie] = action.response.results.map{ $0.id }
            for (_, value) in action.response.results.enumerated() {
                state.movies[value.id] = value
            }
        } else if let action = action as? MoviesActions.SetSearch {
            state.search[action.query] = action.response.results.map{ $0.id }
            for movie in action.response.results {
                state.movies[movie.id] = movie
            }
        } else if let action = action as? MoviesActions.addToWishlist {
            state.wishlist.insert(action.movie)
        } else if let action = action as? MoviesActions.removeFromWishlist {
            state.wishlist.remove(action.movie)
        } else if let action = action as? MoviesActions.addToSeenlist {
            state.seenlist.insert(action.movie)
        } else if let action = action as? MoviesActions.removeFromSeenlist {
            state.seenlist.remove(action.movie)
        } else if let action = action as? MoviesActions.SetMovieForGenre {
            state.genres[action.genre.id] = action.response.results.map{ $0.id }
            for movie in action.response.results {
                if state.movies[movie.id] == nil {
                    state.movies[movie.id] = movie
                }
            }
        }
        return state
    }
}
