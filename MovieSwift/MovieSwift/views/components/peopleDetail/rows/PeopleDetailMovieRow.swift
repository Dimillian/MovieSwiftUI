//
//  PeopleDetailMovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleDetailMovieRow : View {
    @EnvironmentObject var store: Store<AppState>
    
    let movieId: Int
    private var movie: Movie! {
        return store.state.moviesState.movies[movieId]
    }
    let role: String
    
    var body: some View {
        HStack {
            MoviePosterImage(imageLoader: ImageLoader(path: movie.poster_path, size: .small), posterSize: .small)
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                Text(role)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }.contextMenu{ MovieContextMenu(movieId: movieId) }
    }
}

#if DEBUG
struct PeopleDetailMovieRow_Previews : PreviewProvider {
    static var previews: some View {
        PeopleDetailMovieRow(movieId: sampleMovie.id, role: "Test").environmentObject(sampleStore)
    }
}
#endif
