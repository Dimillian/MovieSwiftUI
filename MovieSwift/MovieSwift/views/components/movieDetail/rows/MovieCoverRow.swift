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
    
    struct Props {
        let movie: Movie
    }
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(movie: state.moviesState.movies[movieId]!)
    }
    
    func body(props: Props) -> some View {
        ZStack {
            MovieTopBackdropImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.movie.backdrop_path ?? props.movie.poster_path,
                                                                                 size: .medium),
                                  fill: false)
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.movie.poster_path,
                                                                                    size: .medium),
                                     posterSize: .medium)
                        .padding(.leading, 16)
                    VStack(alignment: .leading, spacing: 16) {
                        MovieInfoRow(movie: props.movie)
                        HStack {
                            PopularityBadge(score: Int(props.movie.vote_average * 10), textColor: .white)
                            Text("\(props.movie.vote_count) ratings")
                                .lineLimit(1)
                                .foregroundColor(.white)
                        }
                    }
                }
                genresBadges(props: props).padding(.top, 16)
            }
        }
        .listRowInsets(EdgeInsets())
    }
    
    private func genresBadges(props: Props) -> some View {
        let fakeGenres = Array(repeating: Genre(id: 0, name: "     "), count: 3)
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(props.movie.genres ?? fakeGenres) { genre in
                    NavigationLink(destination: MoviesGenreList(genre: genre)) {
                        RoundedBadge(text: genre.name, color: .steam_background)
                    }.disabled(props.movie.genres == nil)
                }
            }
            .padding(.leading, 16)
            .redacted(reason: props.movie.genres == nil ? .placeholder : [])
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
