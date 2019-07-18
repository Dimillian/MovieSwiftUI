//
//  MovieContextMenu.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MovieContextMenu: View {
    @EnvironmentObject var store: Store<AppState>
    let movieId: Int
    
    private var isInwishlist: Bool {
        store.state.moviesState.wishlist.contains(movieId)
    }
    
    private var isInSeenList: Bool {
        store.state.moviesState.seenlist.contains(movieId)
    }
    
    private func onWishlistAction() {
        if isInwishlist {
            store.dispatch(action: MoviesActions.RemoveFromWishlist(movie: movieId))
        } else {
            store.dispatch(action: MoviesActions.AddToWishlist(movie: movieId))
        }
    }
    
    private func onSeenlistAction() {
        if isInSeenList {
            store.dispatch(action: MoviesActions.RemoveFromSeenList(movie: movieId))
        } else {
            store.dispatch(action: MoviesActions.AddToSeenList(movie: movieId))
        }
    }
    
    private func onCustomLisrAction(list: Int) {
        if store.state.moviesState.customLists[list]?.movies.contains(movieId) == true {
            store.dispatch(action: MoviesActions.RemoveMovieFromCustomList(list: list, movie: movieId))
        } else {
            store.dispatch(action: MoviesActions.AddMovieToCustomList(list: list, movie: movieId))
        }
    }
    
    private var customLists: some View {
        ForEach(store.state.moviesState.customLists.compactMap{ $0.value }, id: \.id) { list in
            Button(action: {
                self.onCustomLisrAction(list: list.id)
            }) {
                HStack {
                    Text(list.movies.contains(self.movieId) ? "Remove from \(list.name)" : "Add to \(list.name)")
                    Image(systemName: "text.badge.plus").imageScale(.small)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.onWishlistAction()
            }) {
                HStack {
                    Text(isInwishlist ? "Remove from wishlist" : "Add to wishlist")
                    Image(systemName: "heart").imageScale(.small)
                }
            }
            Button(action: {
                self.onSeenlistAction()
            }) {
                HStack {
                    Text(isInSeenList ? "Remove from seenlist" : "Add to seenlist")
                    Image(systemName: "eye").imageScale(.small)
                }
            }
            customLists
        }
    }
    
}

#if DEBUG
struct MovieContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        MovieContextMenu(movieId: 0).environmentObject(sampleStore)
    }
}
#endif
