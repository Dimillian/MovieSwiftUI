//
//  TopRatedList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TopRatedList : View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        NavigationView {
            List(state.moviesState.topRated) { id in
                NavigationButton(destination: MovieDetail(movie: self.state.moviesState.movies[id]!)) {
                    MovieRow(movie: self.state.moviesState.movies[id]!)
                }
            }
            .navigationBarTitle(Text("Top Rated"))
            }.onAppear {
                store.dispatch(action: MoviesActions.FetchTopRated())
        }
    }
}

#if DEBUG
struct TopRatedList_Previews : PreviewProvider {
    static var previews: some View {
        TopRatedList().environmentObject(store)
    }
}
#endif
