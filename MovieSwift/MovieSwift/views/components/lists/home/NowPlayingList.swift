//
//  NowPlayingList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

final class NowPlayingPageListener: PageListener {
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchNowPlaying(page: currentPage))
    }
}


struct NowPlayingList : View {
    @EnvironmentObject var store: AppStore
    @State var pageListener = NowPlayingPageListener()
    
    var body: some View {
        MoviesList(movies: store.state.moviesState.nowPlaying, displaySearch: true, pageListener: pageListener)
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
