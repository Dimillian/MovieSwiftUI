//
//  PopularList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct PopularList : View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        NavigationView {
            List(state.moviesState.popular) { id in
                NavigationButton(destination: MovieDetail(movie: self.state.moviesState.movies[id]!)) {
                    MovieRow(movie: self.state.moviesState.movies[id]!)
                }
            }
            .navigationBarTitle(Text("Popular"))
            }.onAppear {
                store.dispatch(action: MoviesActions.FetchPopular())
        }
    }
}

#if DEBUG
struct PopularList_Previews : PreviewProvider {
    static var previews: some View {
        PopularList().environmentObject(store)
    }
}
#endif
