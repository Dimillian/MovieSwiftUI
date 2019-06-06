//
//  ContentView.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @EnvironmentObject var state: AppState
    
    init() {
        store.dispatch(action: MoviesActions.FetchPopular())
    }
    
    var body: some View {
        List {
            ForEach(state.moviesState.popular) { id in
                Text(self.state.moviesState.movies[id]?.original_title ?? "No title")
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
