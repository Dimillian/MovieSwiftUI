//
//  MoviesGenreList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 15/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MoviesGenreList : View {
    @EnvironmentObject var store: AppStore
    let genre: Genre
    
    var body: some View {
        MoviesList(movies: store.state.moviesState.genres[genre.id] ?? [], displaySearch: false)
            .navigationBarTitle(Text(genre.name))
            .onAppear {
                self.store.dispatch(action: MoviesActions.FetchMoviesGenre(genre: self.genre))
            }
    }
}

#if DEBUG
struct MoviesGenreList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesGenreList(genre: Genre(id: 0, name: "test")).environmentObject(store)
    }
}
#endif
