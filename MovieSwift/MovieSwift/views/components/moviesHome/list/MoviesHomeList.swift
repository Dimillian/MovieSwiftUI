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

struct MoviesHomeList: ConnectedView {
    struct Props {
        let movies: [Int]
    }
    
    @Binding var menu: MoviesMenu
    
    let pageListener: MoviesMenuListPageListener

    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        Props(movies: state.moviesState.moviesList[menu] ?? [0, 0, 0, 0])
    }
    
    func body(props: Props) -> some View {
        MoviesList(movies: props.movies,
                   displaySearch: true,
                   pageListener: pageListener)
    }
}

#if DEBUG
struct MoviesHomeList_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            MoviesHomeList(menu: .constant(.popular),
                           pageListener: MoviesMenuListPageListener(menu: .popular))
                .environmentObject(sampleStore)
        }
    }
}
#endif
