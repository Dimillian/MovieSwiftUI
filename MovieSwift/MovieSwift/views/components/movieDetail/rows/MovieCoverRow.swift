//
//  MovieCoverRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 02/08/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct MovieCoverRow : ConnectedView {
    let movieId: Int
    
    struct Props {
        let movie: Movie
        let isInWishlist: Bool
        let isInSeenlist: Bool
    }
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(movie: state.moviesState.movies[movieId]!,
              isInWishlist: state.moviesState.wishlist.contains(movieId),
              isInSeenlist: state.moviesState.seenlist.contains(movieId))
    }
    
    func body(props: Props) -> some View {
        HStack(spacing: 16) {
            MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.movie.poster_path,
                                                                            size: .medium),
                             posterSize: .medium)
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 8) {
                    BorderedButton(text: props.isInWishlist ? "In wishlist" : "Wishlist",
                                   systemImageName: "heart",
                                   color: .pink,
                                   isOn: props.isInWishlist,
                                   action: {
                                    
                    })
                    
                    BorderedButton(text: props.isInSeenlist ? "Seen" : "Seenlist",
                                   systemImageName: "eye",
                                   color: .green,
                                   isOn: props.isInSeenlist,
                                   action: {
                                    
                    })
                }
                .padding(.vertical, 8)
                
                HStack {
                    PopularityBadge(score: Int(props.movie.vote_average * 10))
                    Text("\(props.movie.vote_count) ratings").lineLimit(1)
                }
            }
        }
    }
}

#if DEBUG
struct MovieCoverRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieCoverRow(movieId: 0).environmentObject(sampleStore)
    }
}
#endif
