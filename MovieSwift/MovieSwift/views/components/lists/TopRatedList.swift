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
            MoviesList(movies: state.moviesState.topRated, displaySearch: true)
            .navigationBarTitle(Text("Top Rated"))
            }.onAppear {
                store.dispatch(action: MoviesActions.FetchTopRated())
        }
    }
}

#if DEBUG
struct TopRatedList_Previews : PreviewProvider {
    static var previews: some View {
        TopRatedList().environmentObject(sampleStore)
    }
}
#endif
