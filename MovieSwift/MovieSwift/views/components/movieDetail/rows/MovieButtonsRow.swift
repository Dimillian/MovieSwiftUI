//
//  MovieButtonsRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/12/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend
import UI

struct MovieButtonsRow: ConnectedView {
    let movieId: Int
    @Binding var showCustomListSheet: Bool
    
    struct Props {
        let movie: Movie
        let isInWishlist: Bool
        let isInSeenlist: Bool
        let isInCustomList: Bool
    }
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(movie: state.moviesState.movies[movieId]!,
              isInWishlist: state.moviesState.wishlist.contains(movieId),
              isInSeenlist: state.moviesState.seenlist.contains(movieId),
              isInCustomList: state.moviesState.customLists.contains(where:
                                                                        { (_, value) -> Bool in
                                                                            value.movies.contains(self.movieId)
                                                                        }))
    }
    
    func body(props: Props) -> some View {
        HStack(alignment: .center, spacing: 8) {
            BorderedButton(text: props.isInWishlist ? "In wishlist" : "Wishlist",
                           systemImageName: "heart",
                           color: .pink,
                           isOn: props.isInWishlist,
                           action: {
                            if props.isInWishlist {
                                store.dispatch(action: MoviesActions.RemoveFromWishlist(movie: self.movieId))
                            } else {
                                store.dispatch(action: MoviesActions.AddToWishlist(movie: self.movieId))
                            }
                           })
            
            BorderedButton(text: props.isInSeenlist ? "Seen" : "Seenlist",
                           systemImageName: "eye",
                           color: .green,
                           isOn: props.isInSeenlist,
                           action: {
                            if props.isInSeenlist {
                                store.dispatch(action: MoviesActions.RemoveFromSeenList(movie: self.movieId))
                            } else {
                                store.dispatch(action: MoviesActions.AddToSeenList(movie: self.movieId))
                            }
                           })
            
            BorderedButton(text: "List",
                           systemImageName: "pin",
                           color: .steam_gold,
                           isOn: props.isInCustomList,
                           action: {
                            self.showCustomListSheet = true
                           })
        }
        .padding(.vertical, 8)
        .animation(.spring())
    }
}

struct MovieButtonsRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieButtonsRow(movieId: 0, showCustomListSheet: .constant(false)).environmentObject(sampleStore)
    }
}
