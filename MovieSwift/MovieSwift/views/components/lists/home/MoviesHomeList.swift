//
//  MoviesHomeList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import SwiftUIFlux

struct MoviesHomeList : View {
    @EnvironmentObject var store: Store<AppState>
    @Binding var menu: MoviesMenu
    
    let pageListener: MoviesHomeListPageListener
    var headerView: AnyView?
    
    private var movies: [Int] {
        store.state.moviesState.moviesList[menu] ?? []
    }
    
    var body: some View {
        MoviesList(movies: movies,
                   displaySearch: true,
                   pageListener: pageListener,
                   headerView: headerView)
            .navigationBarTitle(menu.title())
    }
}

#if DEBUG
struct MoviesHomeList_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MoviesHomeList(menu: .constant(.popular),
                           pageListener: MoviesHomeListPageListener(menu: .popular))
                .environmentObject(sampleStore)
        }
    }
}
#endif
