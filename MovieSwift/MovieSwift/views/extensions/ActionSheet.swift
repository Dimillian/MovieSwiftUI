//
//  ActionSheet.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUIFlux

extension ActionSheet {
    static func wishlistButton(store: Store<AppState>, movie: Int, onTrigger: (() -> Void)?) -> Alert.Button {
        if store.state.moviesState.wishlist.contains(movie) {
            let wishlistButton: Alert.Button = .default(Text("Remove from wishlist")) {
                store.dispatch(action: MoviesActions.RemoveFromWishlist(movie: movie))
                onTrigger?()
            }
            return wishlistButton
        } else {
            let wishlistButton: Alert.Button = .default(Text("Add to wishlist")) {
                store.dispatch(action: MoviesActions.AddToWishlist(movie: movie))
                onTrigger?()
            }
            return wishlistButton
        }
    }
    
    static func seenListButton(store: Store<AppState>, movie: Int, onTrigger: (() -> Void)?) -> Alert.Button {
        if store.state.moviesState.seenlist.contains(movie) {
            let wishlistButton: Alert.Button = .default(Text("Remove from seenlist")) {
                store.dispatch(action: MoviesActions.RemoveFromSeenList(movie: movie))
                onTrigger?()
            }
            return wishlistButton
        } else {
            let wishlistButton: Alert.Button = .default(Text("Add to seenlist")) {
                store.dispatch(action: MoviesActions.AddToSeenList(movie: movie))
                onTrigger?()
            }
            return wishlistButton
        }
    }
    
    static func customListsButttons(store: Store<AppState>, movie: Int, onTrigger: (() -> Void)?) -> [Alert.Button] {
        var buttons: [Alert.Button] = []
        for list in store.state.moviesState.customLists.compactMap({ $0.value }) {
            if list.movies.contains(movie) {
                let button: Alert.Button = .default(Text("Remove from \(list.name)")) {
                    store.dispatch(action: MoviesActions.RemoveMovieFromCustomList(list: list.id,
                                                                              movie: movie))
                    onTrigger?()
                }
                buttons.append(button)
            } else {
                let button: Alert.Button = .default(Text("Add to \(list.name)")) {
                    store.dispatch(action: MoviesActions.AddMovieToCustomList(list: list.id,
                                                                              movie: movie))
                    onTrigger?()
                }
                buttons.append(button)
            }
        }
        return buttons
    }
}
