//
//  MoviesHomeGridMoviesRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 10/10/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend

struct MoviesHomeGridMoviesRow: ConnectedView {
    struct Props {
        let movies: [Movie]
    }
    
    let movies: [Int]
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        var movies: [Movie] = []
        for id in self.movies {
            if let movie = state.moviesState.movies[id] {
                movies.append(movie)
            }
        }
        return Props(movies: movies)
    }
    
    func body(props: Props) -> some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 16) {
                ForEach(props.movies) { movie in
                    NavigationLink(destination: MovieDetail(movieId: movie.id)) {
                        ZStack {
                            MoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: movie.poster_path,
                                                                                            size: .medium),
                                             posterSize: .medium)
                                .contextMenu{ MovieContextMenu(movieId: movie.id) }
                            ListImage(movieId: movie.id)
                        }
                    }
                }
            }
            .frame(height: 150)
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 16)
    }
}

struct MoviesHomeGridMoviesRow_Previews: PreviewProvider {
    static var previews: some View {
        MoviesHomeGridMoviesRow(movies: [])
    }
}
