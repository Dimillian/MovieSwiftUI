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
            if action.page == 1 {
                state.popular = action.response.results.map{ $0.id }
            } else {
                state.popular.append(contentsOf: action.response.results.map{ $0.id })
            }
            for (_, value) in action.response.results.enumerated() {
                state.movies[value.id] = value
            }
        } else if let action = action as? MoviesActions.SetTopRated {
            if action.page == 1 {
                state.topRated = action.response.results.map{ $0.id }
            } else {
                state.topRated.append(contentsOf: action.response.results.map{ $0.id })
            }
            for (_, value) in action.response.results.enumerated() {
                state.movies[value.id] = value
            }
        } else if let action = action as? MoviesActions.SetUpcoming {
            if action.page == 1 {
                state.upcoming = action.response.results.map{ $0.id }
            } else {
                state.upcoming.append(contentsOf: action.response.results.map{ $0.id })
            }
            for (_, value) in action.response.results.enumerated() {
                state.movies[value.id] = value
            }
        } else if let action = action as? MoviesActions.SetNowPlaying {
            if action.page == 1 {
                state.nowPlaying = action.response.results.map{ $0.id }
            } else {
                state.nowPlaying.append(contentsOf: action.response.results.map{ $0.id })
            }
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
            if action.page == 1 {
                state.search[action.query] = action.response.results.map{ $0.id }
            } else {
                state.search[action.query]?.append(contentsOf: action.response.results.map{ $0.id })
            }
            for movie in action.response.results {
                state.movies[movie.id] = movie
            }
        } else if let action = action as? MoviesActions.SetSearchKeyword {
            state.searchKeywords[action.query] = action.response.results
        } else if let action = action as? MoviesActions.addToWishlist {
            state.wishlist.insert(action.movie)
        } else if let action = action as? MoviesActions.removeFromWishlist {
            state.wishlist.remove(action.movie)
        } else if let action = action as? MoviesActions.addToSeenlist {
            state.seenlist.insert(action.movie)
        } else if let action = action as? MoviesActions.removeFromSeenlist {
            state.seenlist.remove(action.movie)
        } else if let action = action as? MoviesActions.SetMovieForGenre {
            state.withGenre[action.genre.id] = action.response.results.map{ $0.id }
            for movie in action.response.results {
                if state.movies[movie.id] == nil {
                    state.movies[movie.id] = movie
                }
            }
        } else if let action = action as? MoviesActions.SetRandomDiscover {
            if state.discover.isEmpty {
                state.discover = action.response.results.map{ $0.id }
            } else {
                state.discover.insert(contentsOf: action.response.results.map{ $0.id }, at: 0)
            }
            for movie in action.response.results {
                if state.movies[movie.id] == nil {
                    state.movies[movie.id] = movie
                }
            }
            state.discoverFilter = action.filter
        } else if let action = action as? MoviesActions.SetMovieReviews {
            state.reviews[action.movie] = action.response.results
        } else if let action = action as? MoviesActions.SetMovieWithCrew {
            state.withCrew[action.crew] = action.response.results.map{ $0.id }
            for movie in action.response.results {
                if state.movies[movie.id] == nil {
                    state.movies[movie.id] = movie
                }
            }
        } else if let action = action as? MoviesActions.SetMovieKeywords {
            state.movies[action.movie]?.keywords = action.keywords
        } else if let action = action as? MoviesActions.SetMovieWithKeyword {
            state.withKeywords[action.keyword] = action.response.results.map{ $0.id }
            for movie in action.response.results {
                if state.movies[movie.id] == nil {
                    state.movies[movie.id] = movie
                }
            }
        } else if let action = action as? MoviesActions.AddCustomList {
            state.customLists.append(action.list)
        } else if let action = action as? MoviesActions.RemoveCustomList {
            state.customLists.removeAll{ $0.id == action.list }
        } else if action is MoviesActions.PopRandromDiscover {
            _ = state.discover.popLast()
        } else if let action = action as? MoviesActions.PushRandomDiscover {
            state.discover.append(action.movie)
        } else if action is MoviesActions.ResetRandomDiscover {
            state.discoverFilter = nil
            state.discover = []
        } else if let action = action as? MoviesActions.SetMovieImages {
            state.movies[action.movie]?.posters = action.response.posters
            state.movies[action.movie]?.backdrops = action.response.backdrops
        } else if let action = action as? MoviesActions.SetGenres {
            state.genres = action.genres
            state.genres.insert(Genre(id: -1, name: "Random"), at: 0)
        }
        return state
    }
}
