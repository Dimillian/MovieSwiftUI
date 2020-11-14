//
//  MovieCoverRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 02/08/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend
import UI

struct MovieCoverRow : ConnectedView {
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
        ZStack {
            MovieTopBackdropImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.movie.backdrop_path ?? props.movie.poster_path,
                                                                                 size: .medium),
                                  fill: false)
            HStack(spacing: 16) {
                MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.movie.poster_path,
                                                                                size: .medium),
                                 posterSize: .medium)
                VStack(alignment: .leading, spacing: 8) {
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
                    }
                    .frame(maxHeight: 40)
                    BorderedButton(text: props.isInCustomList ? "Manage custom list" : "Add to custom list",
                                   systemImageName: "pin",
                                   color: .steam_gold,
                                   isOn: props.isInCustomList,
                                   action: {
                                    self.showCustomListSheet = true
                                   })
                        .padding(.vertical, 8)
                        .frame(maxHeight: 40)
                    
                    HStack {
                        PopularityBadge(score: Int(props.movie.vote_average * 10), textColor: .white)
                        Text("\(props.movie.vote_count) ratings")
                            .lineLimit(1)
                            .foregroundColor(.white)
                    }
                }
            }
        }.listRowInsets(EdgeInsets())
    }
}

#if DEBUG
struct MovieCoverRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieCoverRow(movieId: 0,
                      showCustomListSheet: .constant(false)).environmentObject(sampleStore)
    }
}
#endif
