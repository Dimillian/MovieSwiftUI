//
//  MovieGridRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 24/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend
import UI

struct MovieGridRow: ConnectedView {
    struct Props {
        let movie: Movie
    }
    
    let movieId: Int
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(movie: state.moviesState.movies[movieId]!)
    }
    
    
    func body(props: Props) -> some View {
        MoviePosterImage(posterURL: ImageService.Size.medium.path(poster: props.movie.poster_path ?? ""),
                         posterSize: .medium)
    }
}
