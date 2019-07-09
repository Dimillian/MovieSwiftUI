//
//  TopRatedList.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

final class TopRatedListPageListener: MoviesPagesListener {
    override func loadPage() {
        store.dispatch(action: MoviesActions.FetchTopRated(page: currentPage))
    }
}

struct TopRatedList : View {
    @EnvironmentObject var store: Store<AppState>
    @State var pageListener = TopRatedListPageListener()
    var headerView: AnyView?
    
    var body: some View {
        MoviesList(movies: store.state.moviesState.topRated, displaySearch: true, pageListener: pageListener, headerView: headerView)
            .navigationBarTitle(Text("Top Rated"))
            .onAppear {
                self.pageListener.loadPage()
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
