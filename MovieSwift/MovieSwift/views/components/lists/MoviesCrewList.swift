//
//  MovieCrewList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MoviesCrewList : View {
    @EnvironmentObject var state: AppState
    let crew: Cast

    var body: some View {
        MoviesList(movies: state.moviesState.withCrew[crew.id] ?? [])
            .navigationBarTitle(Text(crew.name))
            .onAppear {
                store.dispatch(action: MoviesActions.FetchMovieWithCrew(crew: self.crew.id))
        }
    }
}

#if DEBUG
struct MovieCrewList_Previews : PreviewProvider {
    static var previews: some View {
        MoviesCrewList(crew: sampleCasts.first!)
    }
}
#endif
