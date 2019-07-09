//
//  NowPlayingList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

final class NowPlayingPageListener: MoviesPagesListener {
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchNowPlaying(page: currentPage))
    }
}


struct NowPlayingList : View {
    @EnvironmentObject var store: Store<AppState>
    @State var pageListener = NowPlayingPageListener()
    var headerView: AnyView?
    
    var body: some View {
        MoviesList(movies: store.state.moviesState.nowPlaying, displaySearch: true, pageListener: pageListener, headerView: headerView)
            .navigationBarTitle(Text("Now Playing"))
            .onAppear {
                self.pageListener.loadPage()
        }
    }
}

#if DEBUG
struct NowPlayingList_Previews : PreviewProvider {
    static var previews: some View {
        NowPlayingList()
    }
}
#endif
