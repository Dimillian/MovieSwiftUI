//
//  MovieDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MovieDetail : View {
    @EnvironmentObject var state: AppState
    let movieId: Int
    var movie: Movie! {
        return state.moviesState.movies[movieId]!
    }
    
    var characters: [Cast]? {
        get {
            guard let ids = state.castsState.castsMovie[movie.id] else {
                return nil
            }
            let cast = state.castsState.casts.filter{ $0.value.character != nil }
            return ids.filter{ cast[$0] != nil }.map{ cast[$0]! }
        }
    }
    
    var credits: [Cast]? {
        get {
            guard let ids = state.castsState.castsMovie[movie.id] else {
                return nil
            }
            let cast = state.castsState.casts.filter{ $0.value.department != nil }
            return ids.filter{ cast[$0] != nil }.map{ cast[$0]! }
        }
    }
    
    var recommanded: [Movie]? {
        get {
            guard let ids = state.moviesState.recommanded[movie.id] else {
                return nil
            }
            let movies = state.moviesState.movies
            return ids.filter{ movies[$0] != nil }.map{ movies[$0]! }
        }
    }
    
    var similar: [Movie]? {
        get {
            guard let ids = state.moviesState.similar[movie.id] else {
                return nil
            }
            let movies = state.moviesState.movies
            return ids.filter{ movies[$0] != nil }.map{ movies[$0]! }
        }
    }
    
    var body: some View {
        List {
            MovieBackdrop(movieId: movie.id)
            MovieOverview(movie: movie)
            CastsRow(title: "Characters",
                     casts: characters ?? []).frame(height: 170)
            CastsRow(title: "Crew",
                     casts: credits ?? []).frame(height: 170)
            MovieDetailRow(title: "Similar Movies", movies: similar ?? []).frame(height: 260)
            MovieDetailRow(title: "Recommanded Movies", movies: recommanded ?? []).frame(height: 260)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
            .onAppear{
                store.dispatch(action: MoviesActions.FetchDetail(movie: self.movie.id))
                store.dispatch(action: CastsActions.FetchMovieCasts(movie: self.movie.id))
                store.dispatch(action: MoviesActions.FetchRecommanded(movie: self.movie.id))
                store.dispatch(action: MoviesActions.FetchSimilar(movie: self.movie.id))
        }
        
    }
    
}

#if DEBUG
struct MovieDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetail(movieId: sampleMovie.id).environmentObject(sampleStore)
        }
    }
}
#endif
