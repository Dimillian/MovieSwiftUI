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
            let wishlistButton: Alert.Button = .destructive(Text("Remove from wishlist")) {
                store.dispatch(action: MoviesActions.RemoveFromWishlist(movie: movie))
                onTrigger?()
            }
            return wishlistButton
        } else {
            let wishlistButton: Alert.Button = .default(Text("Add to wishlist")) {
                store.dispatch(action: MoviesActions.AddToWishlist(movie: movie))
                #if !os(tvOS)
                UISelectionFeedbackGenerator().selectionChanged()
                #endif
                onTrigger?()
            }
            return wishlistButton
        }
    }
    
    static func seenListButton(store: Store<AppState>, movie: Int, onTrigger: (() -> Void)?) -> Alert.Button {
        if store.state.moviesState.seenlist.contains(movie) {
            let wishlistButton: Alert.Button = .destructive(Text("Remove from seenlist")) {
                store.dispatch(action: MoviesActions.RemoveFromSeenList(movie: movie))
                onTrigger?()
            }
            return wishlistButton
        } else {
            let wishlistButton: Alert.Button = .default(Text("Add to seenlist")) {
                store.dispatch(action: MoviesActions.AddToSeenList(movie: movie))
                #if !os(tvOS)
                UISelectionFeedbackGenerator().selectionChanged()
                #endif
                onTrigger?()
            }
            return wishlistButton
        }
    }
    
    static func customListsButttons(store: Store<AppState>, movie: Int, onTrigger: (() -> Void)?) -> [Alert.Button] {
        var buttons: [Alert.Button] = []
        for list in store.state.moviesState.customLists.compactMap({ $0.value }) {
            if list.movies.contains(movie) {
                let button: Alert.Button = .destructive(Text("Remove from \(list.name)")) {
                    store.dispatch(action: MoviesActions.RemoveMovieFromCustomList(list: list.id,
                                                                              movie: movie))
                    onTrigger?()
                }
                buttons.append(button)
            } else {
                let button: Alert.Button = .default(Text("Add to \(list.name)")) {
                    store.dispatch(action: MoviesActions.AddMovieToCustomList(list: list.id,
                                                                              movie: movie))
                    #if !os(tvOS)
                    UISelectionFeedbackGenerator().selectionChanged()
                    #endif
                    onTrigger?()
                }
                buttons.append(button)
            }
        }
        return buttons
    }
    
    static func sortActionSheet(onAction: @escaping ((MoviesSort?) -> Void)) -> ActionSheet {
        let byAddedDate: Alert.Button = .default(Text("Sort by added date")) {
            onAction(.byAddedDate)
        }
        let byReleaseDate: Alert.Button = .default(Text("Sort by release date")) {
            onAction(.byReleaseDate)
        }
        let byScore: Alert.Button = .default(Text("Sort by ratings")) {
            onAction(.byScore)
        }
        let byPopularity: Alert.Button = .default(Text("Sort by popularity")) {
            onAction(.byPopularity)
        }
        
        return ActionSheet(title: Text("Sort movies by"),
                           message: nil,
                           buttons: [byAddedDate, byReleaseDate, byScore, byPopularity, Alert.Button.cancel({
                            onAction(nil)
                           })])
    }
}
